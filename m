Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYEOIgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYEOIgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYEOIgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:36:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56850 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYEOIgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:36:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Date: Thu, 15 May 2008 10:36:08 +0200
User-Agent: KMail/1.9.9
Cc: Bryan Wu <cooloney@kernel.org>, harvey.harrison@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org> <200805150940.34516.oliver@neukum.org> <482BEE57.6040704@analog.com>
In-Reply-To: <482BEE57.6040704@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151036.09386.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Mai 2008 10:03:35 schrieb Jie Zhang:
> Oliver Neukum wrote:
> > Am Donnerstag 15 Mai 2008 08:19:24 schrieb Bryan Wu:
> >> --- a/drivers/usb/host/uhci-hub.c
> >> +++ b/drivers/usb/host/uhci-hub.c
> >> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
> >>         switch (typeReq) {
> >>  
> >>         case GetHubStatus:
> >> -               *(__le32 *)buf = cpu_to_le32(0);
> >> +               put_unaligned_le32(0, buf);
> > 
> > What is supposed to make all these changes a good idea?
> > 
> Since buf might not be 4-byte aligned.

It is. Please analyze the code before you use these access methods.

	Regards
		Oliver
