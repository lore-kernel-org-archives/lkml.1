Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbZEGLEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbZEGLEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZEGLEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:04:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54774 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZEGLEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:04:20 -0400
Date: Thu, 7 May 2009 12:04:17 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Clive Wagenaar <clivewagenaar@gmail.com>
Cc: kernel-team@lists.ubuntu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: Linux ATA Trim support
Message-ID: <20090507110417.GA29166@shadowen.org>
References: <1241682223.3759.67.camel@9200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241682223.3759.67.camel@9200>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 08:43:43AM +0100, Clive Wagenaar wrote:
> Hi Ubuntu kernel Devs
> 
> Could you please advise your thoughts on ATA Trim support in the 9.10,
> Karmic, kernel for SSD drives.
> I am not very clued in as to how far the patches have gotten in the
> mainline kernel of Linus, but I do believe people are working on it and
> it is close now.
> 
> I recently bought a OCZ Vertex 120G SSD drive, as they are the first SSD
> manufacturer to be publicly building tools for ATA trim and have
> indicated that they will have experimental ATA trim support for Linux in
> their next firmware update expected with 2 weeks.
> (Bootchart has 9.04 Juanty booting in 10 seconds off the single ssd of
> OCZ)
> 
> As Windows Vista and 7 do not have ATA trim support yet, they have built
> a exe tool that can be run by Windows uses that trims the SSD, so far it
> works reliably on 32 bit versions of windows. linux uses cant use this
> tool on EXT2/3/4 etc FS from within windows, so a native solution in the
> kernel is the best way to go for Linux.
> 
> OCZ appear to be very proactive with support for ATA Trim, as this is
> VERY important on SSD drives if one does not periodically want to
> re-flash ones drive and then restore a image/re-install.
> 
> Some info on trim:
> http://www.anandtech.com/storage/showdoc.aspx?i=3531&p=10
> 
> Please note that this Trim issue affects all SDD including that ones
> used by Theodore Ts'o and Linus himself. (Intel X25-M)
> Once the drive has had data written to most its 'sectors', write speed
> will drop off drastically and until we have ata trim the only solution
> is to re-flash the drive.
> 
> I am happy to re-flash my drive periodically, but for our Ubuntu for
> humans, it will be great to have ATA trim in Karmic natively.
> 
> I do know the standard is still being finalized, but OCZ are being
> proactive, the mainline kernel guys are too, so I hoping Ubuntu can be
> too.
> 
> 
> If any one has PPA kernels or Linux trim tools that they need me to test
> on my OCZ drive, please do not hesitate to ask, I am more than willing
> to beta test this ATA trim under Linux.
> (I went for the OCZ vertex vs X25-M of Intel, due to the fact that OCZ
> are proactive in their forums and incorporating user feedback into their
> firmware, plus actively working on ATA trim, for both Windows and Linux)

As I understand the current state of play TRIM needs to be supported at
both the filesystem level and at the block levels.  I believe that ext4
is already meant to support trim, and the block layers beneath.  There
is just no support for the actual commands at the physical level.
Though I thought that that was simply because it was not yet actually
standardised.  Given the people affected you can be sure the support
will appear as soon as any devices which have it appear in the hands of
Ted and the like.

As for whether that hits Karmic, that would depend on when it arrives in
mainline.  If it does not land there soon enough you would probabally be
able to test it out using the mainline builds we supply.

-apw
