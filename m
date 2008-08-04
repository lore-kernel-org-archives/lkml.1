Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbYHDWUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbYHDWUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbYHDWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:19:55 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752629AbYHDWTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:19:54 -0400
Date: Mon, 4 Aug 2008 17:19:53 -0500
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number on SGI UV
Message-ID: <20080804221951.GA252105@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48934926.2010200@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 10:34:30AM -0700, H. Peter Anvin wrote:
> Russ Anderson wrote:
> >x86 BIOS interface for partitioning and system serial number on SGI UV
> 
> >-	if (!proc_mkdir("sgi_uv", NULL))
> >+	if (!sgi_uv_dir)
> >+		sgi_uv_dir = proc_mkdir("sgi_uv", NULL);
> >+	if (!sgi_uv_dir)
> > 		return -EINVAL;
> 
> This really seems more that it should belong in sysfs -- 
> /sys/class/firmware presumably.

/proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.

Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
seems to indicate somewhere under /sys/devices, such as /sys/devices/system/,
but I may be wrong.

> >+# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
> >+	do {								\
> >+		/* XXX - the real call goes here */			\
> >+		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
> >+		result.v0 = 0;						\
> >+		result.v1 = 0;						\
> >+	} while (0)
> 
> I have more than a little problem with submitting patches like this.  We 
> have no way to judge the suitability of the coding or the interface with 
> the "meat" of the driver stubbed out!

This is also code for hardware that does not exist.  In order for the
code to be in distro releases in time for the hardware to ship, we
must push it _before_ we have hardware.  The main concern is getting in
interfaces now, because the interfaces cannot change in a minor release.
Providing more "meat" is on the ToDo list.  

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
