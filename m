Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYHKOuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYHKOuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYHKOt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:49:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYHKOtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:49:55 -0400
Message-ID: <48A05169.2090303@redhat.com>
Date: Mon, 11 Aug 2008 16:49:13 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@qumranet.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Use of barriers in pvclock ABI
References: <489CA3DA.1090400@goop.org> <489FE56E.1080707@redhat.com> <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
In-Reply-To: <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> On Mon, Aug 11, 2008 at 4:08 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>> Due to the TSC being involved here I don't expect cross-cpu time updates
>> will ever happen.  IMHO it is fine to change that.
> 
> Okay for guest vcpu, but what about physical cpus?
> 
> IIRC, the checks are there, and so strict, to account for the
> possiblity of the vcpu to be migrated to another cpu in the middle of
> the
> clock reading.

This is about the check in pvclock_get_time_values() that it got a
consistent snapshot.  Dropping that is fine.

pvclock_clocksource_read() will still notice when being migrated to
another pcpu in the middle of the clock reading.

cheers,
  Gerd

-- 
http://kraxel.fedorapeople.org/xenner/
