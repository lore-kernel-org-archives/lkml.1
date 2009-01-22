Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZAVUd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZAVUd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbZAVUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:33:06 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2922 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785AbZAVUdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:33:05 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Thu, 22 Jan 2009 12:32:52 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Tarkan Erimer" <tarkan.erimer@turknet.net.tr>
cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
Message-ID: <20090122203252.GA3258@xw6200.broadcom.net>
References: <49771D65.3090205@turknet.net.tr>
 <20090121152818.GA3438@x200.localdomain>
 <497870A3.4070200@turknet.net.tr>
MIME-Version: 1.0
In-Reply-To: <497870A3.4070200@turknet.net.tr>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-WSS-ID: 6566087C61S37204099-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 05:12:03AM -0800, Tarkan Erimer wrote:
> Alexey Dobriyan wrote:
> > # CONFIG_FIRMWARE_IN_KERNEL is not set
> >   
> >
> > Try setting this option to =y.
> >   
> 
> Thanks for the reply. I tried with "CONFIG_FIRMWARE_IN_KERNEL=y" as you 
> suggested. But, still I get the same warning.
> It looks like ubuntu's make-kpkg utility or kernel compile process do 
> not care about "CONFIG_FIRMWARE_IN_KERNEL=y" and still building modules 
> without firmware built-in.

The error message is coming from the
/usr/share/initramfs-tools/hook-functions script.  You are right that
the script does not look at the config file for
CONFIG_FIRMWARE_IN_KERNEL=y, but I'm not sure if it should or not.

The script uses the command 'modinfo -F firmware tg3' to determine
whether or not it should include firmware images in the initrd.  The
modinfo command simply inspects the tg3.ko module binary reports if the
module makes any firmware requests.  Obviously this isn't the complete
picture.

Somewhere in this process, the script or modinfo needs to find out if
the kernel has firmware images builtin.  How this gets accomplished is
probably best left to the script maintainers.

