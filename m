Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXDDRfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXDDRfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXDDRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:35:48 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55270 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbXDDRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:35:43 -0400
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>,
       Promise_Linux <Promise_Linux@promise.com>
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F0327ED0C@nonameb.ptu.promise.com>
References: <B70A50D07063384EB9BCE3330D18414F0327ED0C@nonameb.ptu.promise.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:35:39 -0500
Message-Id: <1175708139.3693.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 10:31 -0700, Ed Lin wrote:

> Sorry. It seems the mail server has problem. The patch is here in plain
> text. I hope this time it does not mess up. I have problem with
> linux-scsi
> mail list, if you have comment please cc me. Thanks.
> --Ed Lin

The lines are still broken, I'm afraid ... you can just resend as an
attachement git-applypatch copes fine with that ... inline is just good
for quoting and replying.
> +	if (hba->cardtype == st_shasta) {
> +		host->max_channel = 7;
> +		host->max_id = 16 + 1;
> +	} else if (hba->cardtype == st_yosemite) {
> +		host->max_channel = 127;
> +		host->max_id = 1 + 1;
> +	} else {
> +		/* st_vsc and st_vsc1 */
> +		host->max_channel = 0;
> +		host->max_id = 128 + 1;

This is OK.  The use of ->channel is still a bit strange ... could we
not simply use lun instead of channel (i.e. map the adapter id/lun to
the mid-layer id/lun instead of using id/channel)?

James


