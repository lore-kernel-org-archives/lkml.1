Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760Ab0AVB7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0AVB7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713Ab0AVB7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:59:38 -0500
Received: from hq-exedge.brocade.com ([66.243.153.82]:22568 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0AVB7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:59:37 -0500
From: Jing Huang <huangj@Brocade.COM>
To: Roel Kluin <roel.kluin@gmail.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
CC: Adapter Linux Open SRC Team 
	<adapter_linux_open_src_team@Brocade.COM>
Date: Thu, 21 Jan 2010 17:59:35 -0800
Subject: RE: [PATCH] bfa: comparison with wrong msgtag in bfa_pport_isr()
Thread-Topic: [PATCH] bfa: comparison with wrong msgtag in bfa_pport_isr()
Thread-Index: AcqZQ97xYx5NM3jgQQK774DVb9DBHABwEXcQ
Message-ID: <04391A4E90BB2149B010D22452FA16875F0348DF@HQ-EXCH-6.corp.brocade.com>
References: <4B56136F.3070709@gmail.com>
In-Reply-To: <4B56136F.3070709@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Was this maybe intended? otherwise in case BFI_PPORT_I2H_ENABLE_RSP:
> the same code is executed. Please review.

Making this change alone will break compilation since bfa_pport_disable_rsp_s is not defined. To fix this, we should also replace it with bfa_pport_generic_rsp_s in bfi_pport_i2h_msg_u.

But please keep this as it is for now since I am working on resubmitting 2.1.2.1 patch, and there are a lot of changes in this area.

Thanks

Jing

> 
> diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
> index aef648b..f00d07b 100644
> --- a/drivers/scsi/bfa/bfa_fcport.c
> +++ b/drivers/scsi/bfa/bfa_fcport.c
> @@ -918,7 +918,7 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s
> *msg)
>  		break;
> 
>  	case BFI_PPORT_I2H_DISABLE_RSP:
> -		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
> +		if (pport->msgtag == i2hmsg.disable_rsp->msgtag)
>  			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
>  		break;
> 
