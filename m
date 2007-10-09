Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXJIQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXJIQmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXJIQlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:41:50 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:22832 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXJIQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:41:49 -0400
Date: Tue, 9 Oct 2007 09:41:47 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: James Smart <James.Smart@Emulex.Com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Message-ID: <20071009164147.GB19854@plap3.qlogic.org>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org> <470B9E50.2090205@emulex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470B9E50.2090205@emulex.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 09 Oct 2007 16:40:34.0540 (UTC) FILETIME=[1D2392C0:01C80A93]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Oct 2007, James Smart wrote:

>  Why do you prefer request_firmware() vs something over sysfs ?
> 
>  Does environments like the kdump kernel also have access to data needed
>  by request_firmware() ?

There's already much in the way of automation and infrastructure
present in supporting the request_firwmare() interfaces (perhaps not
the best of names) which can provide for a level of flexibility beyond
a basic 'soft_port_name' interface.

Though I don't see why both can't coexist cleanly -- I take it the use
case you are considering is: software recognizes no valid WWPN
available, query via request_firmware() fails, software halts
initialization (rather than fail), and awaits the admin to poke
'0x123456.. > /sys/.../fc_host/soft_port_name', causing a ping to the
driver and continuation of initialization with requested portname?
