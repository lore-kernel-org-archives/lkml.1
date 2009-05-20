Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZETKMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZETKMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZETKM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:12:26 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:53997 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZETKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:12:25 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Marcin Krol <mrkafk@gmail.com>
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
Date: Wed, 20 May 2009 11:12:24 +0100
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A13CCE1.5000106@gmail.com>
In-Reply-To: <4A13CCE1.5000106@gmail.com>
MIME-Version: 1.0
Message-Id: <200905201112.24401.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/05/2009 11:12:24,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/05/2009 11:12:25,
	Serialize complete at 20/05/2009 11:12:25
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009 10:26:57 Marcin Krol wrote:
> Hello everyone,
>
> First, apols for using up bandwidth, but I honestly found no other place
> where I can ask about this (and get meaningful reply).
>
> I'm not a kernel programmer, but I want to develop a program that would
> watch modifications in *all* user directories on a busy server using
> inotify.
>
> This is for high-availability purposes - events would be collected and
> once every several minutes changed dirs would be rsync'ed to failover
> server or smth like that would be done.
>
> As inotify watches particular directory and not its subdirs, I would
> have to watch all directories.
>
> This means I would have to create thousands or even tens of thousands of
> inotify watches.
>
> So my questions are:
>
> 1. is it safe? that is, will it not lock the kernel up, or cause
> excessive memory consumption?
>
> 2. is it economic in terms of CPU time and RAM? I have no idea how to
> even measure such a thing happening in the kernel..

Hi,

I don't know the specific answers apart my intuitive feeling, which is that it 
probably would cause excessive memory use and that it is not elegant at all.

What may be interesting to you is the notification "engine" rewrite Eric Paris 
is doing and new fanotify interface which will, hopefully, come soon on top 
of it. With fanotify you will be able to monitor all changes much more easily 
and efficiently.

Have a look at patch descriptions in:
http://people.redhat.com/~eparis/fsnotify/

Tvrtko
