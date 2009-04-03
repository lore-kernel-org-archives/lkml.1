Return-Path: <linux-kernel-owner+w=401wt.eu-S936891AbZDCUoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936891AbZDCUoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937099AbZDCUme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:42:34 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:44976 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937078AbZDCUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:42:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HdS71jGgSj8FvImpWwBdvEFNUECf/HUuONqZVgYD43YQjb+YCzspTJBA6YkffdQ6WYjxEmy8g6SV7MIZVLtZZmF/OF714MTJAnk3ma75yAD3Iq+JyDTqOt6RxzTIPsBBh2EYJguI3Vi2Se4Tcmabak9tMz1YM9bfEA6/sVgQ0TE=  ;
X-YMail-OSG: MX.nNwwVM1mFNwhhaL6aHJg53Oi8lx3Z9zZEhjrMkrr.d.DTq.I2e6KOij4dYgp3BaOjTQsnF5UfIrMwRrnGG0WbTiNQqlSaaqEB7Oty10DlsZtx6XGdufCOznkyh9b417OcwdnZ19Wc2MOZbA8MXThqp8mU7Yfp4GRzTrprsyGT5y71ZBi9350Mve02ynlcyXh.OFxkUC.YmnBSYgW3iW.6ARFKWFfLLu0QOL9vMCA1GMLIqPR0_F.ffNR2klC2zqqEqVZzvp9lpocJ1w4XiC99nEYq4sC8AizkzFnvJC5A8kTSwFpZ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Eugene T. Bordenkircher" <eugebo@gmail.com>
Subject: Re: Problem with f_rndis.c
Date: Fri, 3 Apr 2009 13:42:29 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <49D62418.6080405@gmail.com>
In-Reply-To: <49D62418.6080405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904031342.29960.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Eugene T. Bordenkircher wrote:
> The following is an artifact in f_rndis.c that is present because of the USB
> gadget refactoring
> 
> 679         rndis_set_param_medium(rndis->config, NDIS_MEDIUM_802_3, 0);
> 680         rndis_set_host_mac(rndis->config, rndis->ethaddr);
> 681
> 682 #if 0
> 683 // FIXME
> 684         if (rndis_set_param_vendor(rndis->config, vendorID,
> 685                                 manufacturer))
> 686                 goto fail0;
> 687 #endif
> 688
> 689         /* NOTE:  all that is done without knowing or caring about
> 690          * the network link ... which is unavailable to this code
> 691          * until we're activated via set_alt().
> 
> The bad news is that I'm hitting an oops because of it.
> 
> Newer versions of the windows rndis driver never seem to call
> OID_GEN_VENDOR_DESCRIPTION so this isn't a problem.  However, older versions of
> XP SP2 and earlier machines still call this, and since the vendor string is
> never set in rndis_per_dev_params(rndis.c) the kernel ends up SEGV'ing by
> accessing the null pointer for the vendor string.
> 
> I played around with this for about 3-4 hours yesterday trying to get the
> vendorID and manufacturer in some reasonable manner, but could not find a way
> to backtrack to them.
> 
> Any suggestions to help me fix it? or even better solutions? :) I have plenty
> of boxes that are oops'ing so I can test solutions as needed.

Maybe just add more params to rndis_bind_config() and
call that code from there.

