Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZCaHfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZCaHfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZCaHew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:34:52 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60579 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZCaHev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:34:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
Date: Tue, 31 Mar 2009 09:39:08 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net> <200903300828.45337.oliver@neukum.org> <49D0EC24.4080206@lwfinger.net>
In-Reply-To: <49D0EC24.4080206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903310939.09690.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 März 2009 17:58:28 schrieb Larry Finger:
> Oliver Neukum wrote:

> > Thanks for this report and the patch. I think, however that it introduces
> > unneeded locking. It seems to me that we should be fine if we fix
> > kaweth_start_xmit(). That code assumes that it is called with interrupts
> > off and under a spinlock. Is that incorrect?
>
> You are correct in that only the locking in kaweth_start_xmit() needs to be
> changed to lock out the other CPU's. In my testing under extreme conditions

Very good.

> (X server over the network), the interface stalled with no logged messages.

Do you get something with sysrq-t ?

	Regards
		Oliver

