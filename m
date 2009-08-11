Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZHKSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZHKSqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZHKSqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:46:33 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:26197 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZHKSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:46:32 -0400
Date: Tue, 11 Aug 2009 11:45:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1271: fix compiler warnings on 64 bit archs
Message-Id: <20090811114518.d45d4006.randy.dunlap@oracle.com>
In-Reply-To: <4A81BB47.2020607@nokia.com>
References: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com>
	<20090811200746.cde6aed9.sfr@canb.auug.org.au>
	<4A81BB47.2020607@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A81BC77.0040:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 21:41:11 +0300 Luciano Coelho wrote:

> ext Stephen Rothwell wrote:
> > Hi Luciano,
> >
> > On Tue, 11 Aug 2009 11:58:27 +0300 Luciano Coelho <luciano.coelho@nokia.com> wrote:
> >   
> >> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
> >> @@ -100,8 +100,8 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
> >>  
> >>  	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
> >>  
> >> -	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", fw_data_len,
> >> -		CHUNK_SIZE);
> >> +	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d",
> >> +		     (u32) fw_data_len, CHUNK_SIZE);
> >>     
> >
> > fw_data_len is a size_t and so should be printed with %zd.
> >
> >   
> >> @@ -148,7 +148,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
> >>  	addr = dest + chunk_num * CHUNK_SIZE;
> >>  	p = buf + chunk_num * CHUNK_SIZE;
> >>  	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
> >> -		     fw_data_len % CHUNK_SIZE, p, addr);
> >> +		     (u32) fw_data_len % CHUNK_SIZE, p, addr);
> >>     
> >
> > ditto.
> >   
> 
> Thanks! I didn't know about the z length modifier for printf (everyday 
> learning something new!), I should have checked the manpage.  I'll fix 
> this and send v2 of my patch.

man page is fine, but you can also check (in the kernel source tree)
Documentation/printk-formats.txt


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
