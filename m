Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0CKBUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 20:20:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0CKBUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 20:20:35 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Date: Thu, 11 Mar 2010 02:20:28 +0100
User-Agent: KMail/1.9.10
Cc: David Rees <drees76@gmail.com>
References: <201003101817.42812.hpj@urpla.net> <72dbd3151003101544w18afc65ubbc85d5bfc435198@mail.gmail.com>
In-Reply-To: <72dbd3151003101544w18afc65ubbc85d5bfc435198@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003110220.28535.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18DqKa5l0V8wHg3PS1kqSdqntad9DllpSDeewR
 hkwrcDdGrNou8/9YaAp2chtkSUrew+AZ8vr3677UTNaRkHQ+i5
 Q/jYxjtlwF9yB1TuGh4pA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, 00:44:54 David Rees wrote:
> On Wed, Mar 10, 2010 at 9:17 AM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> > While this system usually operates fine, it suffers from delays, that
> > are displayed in latencytop as: "Writing page to disk:     8425,5 ms":
> > ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec
> > range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png,
> > ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.
> >
> > From other observations, this issue "feels" like it is induced by
> > single syncronisation points in the block layer, eg. if I create heavy
> > IO load on one RAID array, say resizing a VMware disk image, it can
> > take up to a minute to log in by ssh, although the ssh login does not
> > touch this area at all (different RAID arrays). Note, that the
> > latencytop snapshots above are made during normal operation, not this
> > kind of load..
> >
> > Might later kernels mitigate this problem? As this is a production
> > system, that is used 6.5 days a week, I cannot do dangerous
> > experiments, also switching to 64 bit is a problem due to the legacy
> > stuff described above... OTOH, my users suffer from this, and anything
> > helping in this respect is highly appreciated.
>
> Seems like a 2.6.32 based kernel which has per-BDI writeback and "CFQ
> low latency mode" changes might help a good deal.  I know that on one
> of my bigger machines (similar in specs to yours) which has a lot of
> processes which do a decent amount of IO, latency and load average has
> gone down after going to a 2.6.32 kernel from a 2.6.31 kernel (Fedora
> 11 system).
>
> Like Chris suggested, I've also heard that using the noop IO scheduler
> can work well on Areca controllers on some kernels and workloads.
> It's worth a shot and you can even try changing it at run-time.

Yes, already done. Hopefully my users will notice.. As I've upgraded this 
server and the clients only two weeks ago, calming things down has highest 
priority.

Switching kernel versions in production systems is always painful, thus I  
try to avoid that, but this time I already needed to roll my own kernel for 
the clients due to some aufs2 vs. apparmor disharmony. That led to the loss 
of the latter - I can live without apparmor, but certainly not without a 
reliable layered filesystem¹.
 
Anyway, thanks for your suggestion and confirmation, David. It is 
appreciated.

Cheers,
Pete

¹) In a way, this is my primary justification to also use Linux on the 
desktops²! Install one, and get the rest (nearly) free.. 
http://download.opensuse.org/repositories/home:/frispete:/aufs2 and below..
²) Don't tell anybody, that I don't like the other OS ;-)
