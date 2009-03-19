Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZCSRJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZCSRJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZCSRJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:09:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:55434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZCSRJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sDD//5SwUYXohfouAnUi8EVsLvOMNaW2QsXFrInvK95QqYujewICBmGlJkd77SeIxZ
         QDWEeN1y3nlEVXQ4eFXPTSAhngtDnvLJ9JNMprE3NAqZyAVtAgCBY7vfubL2Zou4MMdF
         Qk13yd5E0CgYW0kF13wGFSfKz33gN6QQs/eXQ=
MIME-Version: 1.0
In-Reply-To: <87ljr21jo4.fsf@basil.nowhere.org>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <87ljr21jo4.fsf@basil.nowhere.org>
Date: Thu, 19 Mar 2009 10:08:59 -0700
X-Google-Sender-Auth: 9505f6bfd212fbc7
Message-ID: <e9c3a7c20903191008y5262a991ufefd17254075c977@mail.gmail.com>
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
From: Dan Williams <dan.j.williams@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 4:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> This series constitutes the pieces of the raid6 acceleration work that are
>> aimed at the next merge window.  It implements:
>> 1/ An api for asynchronous raid6 parity generation and recovery routines
>
> Could you please comment a bit how well the default load balancing works. If
> I write a single stream from a single CPU will it use multiple CPU
> cores in the system to do the RAID6 work?

No, that is an item for the todo list.  This implementation is only
asynchronous when a raid6 hardware offload resource is available, when
this is not the case it runs synchronous/single-threaded.  In general
the api is meant to inherit the load balancing of the caller.  For
md/raid6 this is currently always single threaded for writes and
degraded reads regardless of the number of requesting threads.

This work does make some progress towards multithreaded raid6 in that
calculations can now be preempted (i.e. no longer performed under the
stripe spin_lock).

--
Dan
