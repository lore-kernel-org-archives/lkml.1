Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbYEVWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbYEVWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935180AbYEVWA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:00:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47302 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762748AbYEVWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:00:26 -0400
Date: Thu, 22 May 2008 14:58:12 -0700
From: Greg KH <greg@kroah.com>
To: Sean Hefty <sean.hefty@intel.com>
Cc: rolandd@cisco.com, hal.rosenstock@gmail.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: question about drivers/infiniband/core/cm.c's kobject usage
Message-ID: <20080522215812.GA3366@kroah.com>
References: <20080522203403.GA27263@kroah.com> <000501c8bc55$7c2dd680$ec248686@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501c8bc55$7c2dd680$ec248686@amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 02:47:51PM -0700, Sean Hefty wrote:
> >So I was curious, was this done on purpose?  If so, why?  If not, any
> >objection to me switching it over to be using struct device properly?
> 
> It's entirely possible I have this wrong, but the intent is to export some
> infiniband communication management message counters and relate them to the
> corresponding ib_device/port.  For example:
> 
> /sys/class/infiniband_cm/<device name>/<port number>/<counter group>/<counter>
> 
> (E.g. /sys/class/infiniband_cm/mthca0/1/cm_tx_msgs/req)
> 
> If there's a better way to handle this, I have no objection to changing it.

Yes, just hang all of the <port number> stuff off of the original
<device name> struct device.  That seems like it would be much simpler.

thanks,

greg k-h
