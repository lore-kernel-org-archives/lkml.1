Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZGOLzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZGOLzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZGOLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:55:39 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:45561 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZGOLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=px1qTGTdGAsMld6hDAKvRFdg539os8TIOVemlgNCwQiZSMbIYKBLLJFc9eDzdfB9IS
         ZTe/X0sqYImciG43yQAc4IIJQSRxbjv9HRs098UtJaKgR6xYbyOrKRQnxs+ycJhFmhFP
         ks8aP3R3HHrq1LzctAZTv34JIR1xC6YtG+k/8=
MIME-Version: 1.0
In-Reply-To: <2898.1247658300@redhat.com>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> 
	<20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com> 
	<4A5CFFD8.7020106@t-online.de> <12377.1247654255@redhat.com> 
	<8bd0f97a0907150412h234cf4d6l439d92d832055373@mail.gmail.com> 
	<2898.1247658300@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 07:55:18 -0400
Message-ID: <8bd0f97a0907150455l59a86540l655604579ab70b4f@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] NOMMU: add support for Memory 
	Protection Units (MPU)
To: David Howells <dhowells@redhat.com>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 07:45, David Howells wrote:
> Mike Frysinger wrote:
>> there is full 4k page protection between processes and between the
>> kernel and processes.
>
> So you have a separate bitmap per process?

yes, you can see page_rwx_mask in our mmu.h's mm_context_t.  this is
what the protect_page/update_protections operate on.  we have a global
current_rwx_mask that gets updated during context changes and the CPLB
miss handler uses that to keep things simple.
-mike
