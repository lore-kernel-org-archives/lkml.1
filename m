Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZC3GYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZC3GYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZC3GYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:24:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55307 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC3GYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:24:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
Date: Mon, 30 Mar 2009 08:28:44 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net>
In-Reply-To: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903300828.45337.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 März 2009 01:32:34 schrieb Larry Finger:
> On an SMP system, the following message is printed. The patch below gets
> fixes the problem.

Thanks for this report and the patch. I think, however that it introduces
unneeded locking. It seems to me that we should be fine if we fix
kaweth_start_xmit(). That code assumes that it is called with interrupts
off and under a spinlock. Is that incorrect?

	Regards
		Oliver

