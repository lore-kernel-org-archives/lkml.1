Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZFVTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZFVTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZFVTb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:31:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZFVTbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:31:25 -0400
Message-ID: <4A3FDBFE.8050509@2net.co.uk>
Date: Mon, 22 Jun 2009 20:31:10 +0100
From: Chris Simmonds <chris@2net.co.uk>
Reply-To: chris@2net.co.uk
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Marco <marco.stornelli@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de>
In-Reply-To: <200906222033.20883.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+fvW/qtPWHM2CzSuqwh3xm2L6qfWNo98dtdPY
 67tuhicUGaIeTKkdV+mtdBw7ei+Jdu2PfNIEm5tzNk7NkQj7E5
 U4KWBin2GJi7TEjLsDRENiI8H90Gs76cMgfXZX3VKc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 22 June 2009, Marco wrote:
>> Sorry, I meant it's not currently possible. At the moment the only way
>> to use it as rootfs it's to copy all the data in an already mounted
>> (empty) ram partition and reboot. However it's not my first item on my
>> todo list because I think that it's possible to use it as rootfs but it
>> isn't the standard use for this fs.
> 
> Well, it doesn't have to work right away. What I'm asking to
> define the data structures in a way that keeps the layout stable
> across kernel updates. Since a future version of the file system
> might support cross-endian image creation, it would be good to
> define the data structures in a fixed endian mode already, so
> you don't have to change it in the future.
> 
> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-embedded" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I disagree: that adds an unnecessary overhead for those architectures 
where the cpu byte order does not match the data structure ordering. I 
think the data structures should be native endian and when mkpramfs is 
written it can take a flag (e.g. -r) in the same way mkcramfs does.

Chris Simmonds
