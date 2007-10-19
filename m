Return-Path: <linux-kernel-owner+w=401wt.eu-S936375AbXJSThb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375AbXJSThb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXJSThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:37:16 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44090 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757094AbXJSThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:37:14 -0400
Message-ID: <4719075E.4080204@lwfinger.net>
Date: Fri, 19 Oct 2007 14:37:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, xemul@openvz.org
Subject: Re: Network failure with 2.6.23-git14
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My network also fails - my interface is a BCM4311 using b43 as the driver.

Upon bisecting, I find that d3904b739928edd83d117f1eb5bfa69f18d6f046 is first bad commit

commit d3904b739928edd83d117f1eb5bfa69f18d6f046
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Wed Oct 17 21:22:17 2007 -0700

    [NET]: Cleanup the error path in sk_attach_filter

    The sk_filter_uncharge is called for error handling and
    for releasing the former filter, but this will have to
    be done in a bit different manner, so cleanup the error
    path a bit.

    Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 4701c69aafadaac36e6a605fd7b06008dd175f4b 7951c5cfcb941609f8d22a5117c7dcb40e69b1e7 M
    net

Larry
