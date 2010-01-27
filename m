Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438Ab0A0LNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab0A0LNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427Ab0A0LNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:13:37 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:45297 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0A0LNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BR+Uzg5ODh9iS7kFSQY/idTBFSccn8usudxkefQ14wItLaIx/5Z7hBJyUFrmmqOj/C
         llfkRa/Wl24OAmhucuJqC8wg/4180n3WbiF/SYWgam1CAvnRhyxycYNFQu4Ix/fSbs4K
         vADn7LHYuArbsl/hx3O8eZcFfX969kV5Q3eLw=
Date: Wed, 27 Jan 2010 14:13:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug list: assigning negative values to unsigned variables
Message-ID: <20100127111325.GC24796@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100127104011.GA24796@bicker> <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001271155430.20256@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:57:06AM +0100, Julia Lawall wrote:
> On Wed, 27 Jan 2010, Dan Carpenter wrote:
> 
> > Fixing the places which assign negative values to unsigned variables is a good janitor task.
> 
> I had the impression that assignment to -1 was done sometimes as a 
> portable way to initialize the variable to 0xffff (for any number of f's).  
> So perhaps it is not so trivial to fix.
> 
> julia
> 

The grep removed those.

> > This list is from smatch:  grep -w "fit into 0" warns.txt | grep -v "\-1" | tee err-list

Also it removed some other real bugs as well, which I have listed below.  It 
should have been:  grep -w "fit into 0" warns.txt | grep -vw "\-1" | tee err-list

But you are right assigning -1 is idiomatic.  I'll push a change tomorrow so 
the grep isn't needed.

regards,
dan carpenter

drivers/net/bnx2x_link.c +864 bnx2x_cl45_write(38) warn: value -14 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +884 bnx2x_cl45_write(58) warn: value -14 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +934 bnx2x_cl45_read(40) warn: value -14 can't fit into 0 'rc'
drivers/net/bnx2x_link.c +957 bnx2x_cl45_read(63) warn: value -14 can't fit into 0 'rc'
drivers/pci/hotplug/ibmphp_hpc.c +391 pci_ctrl_write(2) warn: value -19 can't fit into 0 'rc'
drivers/usb/serial/iuu_phoenix.c +573 iuu_clk(133) warn: value -124 can't fit into 0 '*(priv->buf+Count++)'
net/llc/llc_station.c +691 llc_station_init(2) warn: value -105 can't fit into 0 'rc'
net/wireless/wext-compat.c +175 cfg80211_wext_giwrange(34) warn: value -110 can't fit into 0 'range->max_qual.level'
