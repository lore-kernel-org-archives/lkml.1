Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZBFXSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZBFXSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZBFXSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:18:15 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37359 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZBFXSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f//5lG0PurayimpiuHMz1yr4fBbKm94ven4Gn2mFmHIW0+hOtqfhA4w/RdZRvUHllj
         PIol68zONLi93sG00j1EASLeuPh8YGOl0TdVP1UW3GLlEit1fnb0N6pSP45bhEK6BBhz
         1h4iO86C2k7We+VPipsG0AABvF6Mc3QQM51Gg=
MIME-Version: 1.0
In-Reply-To: <20090205074740.224f7b1f@infradead.org>
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz>
	 <20090203133251.GD29046@elte.hu> <gmeu0q$n13$1@ger.gmane.org>
	 <20090205150705.GC6865@nostromo.devel.redhat.com>
	 <20090205071444.390c19bc@infradead.org>
	 <20090205152442.GE6865@nostromo.devel.redhat.com>
	 <20090205074740.224f7b1f@infradead.org>
Date: Sat, 7 Feb 2009 00:18:11 +0100
Message-ID: <4e5e476b0902061518l7370fad2x7687471ce9acc239@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bill Nottingham <notting@redhat.com>, Harald Hoyer <harald@redhat.com>,
       linux-kernel@vger.kernel.org, power@bughost.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 4:47 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> another issue with the "use strace" approach is selinux...
> (this is in addition to the performance and behavioral changes)

Regarding behavioral changes, we should consider that just introducing
sreadahead in the boot process will change the system behaviour,
especially with distros that try and start multiple processes in
parallel during boot.

This means that, in order to approximate the optimal boot, sreadahead
should monitor every boot (even when it is performing readahead), and
modify the order of the opened files accordingly.
I'm using a modified sreadahead version that implements this (on top
of original ext3 patch), and the number of I/O waits shown by
bootchart reduced noticeably w.r.t. naive sreadahead.

So the assumption that just 1 slow boot is enough doesn't hold. We
should try to have a low overhead tracing system in the kernel, to be
able to implement this more efficiently.

Corrado
