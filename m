Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbXLJUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbXLJUEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXLJUES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:04:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:21763 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbXLJUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=LLSOvnOCVSJN9jdjyN5gpeBTNLT3ZG2QGtlX+OkYUrwIKU9nFKrj6bmQ811uY0iqQ4CSkNg3wE1sMw1YFgfOzmg3E8ybupWVzS8gwOpbhGOQ8b7g4VZ1aHGMEQ+HgNv2/3/+Ze0KLN+szJMtEjWdUO6boRwp+bSj4yseW1Y5dno=
Message-ID: <170fa0d20712101204u7add338ah5d05d4d2501432d6@mail.gmail.com>
Date: Mon, 10 Dec 2007 15:04:14 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 003 of 3] md: Update md bitmap during resync.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1071207054200.7907@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_18091_21201694.1197317054351"
References: <20071207163806.7539.patches@notabene> <1071207054200.7907@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_18091_21201694.1197317054351
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Dec 7, 2007 12:42 AM, NeilBrown <neilb@suse.de> wrote:
>
> Currently and md array with a write-intent bitmap does not updated
> that bitmap to reflect successful partial resync.  Rather the entire
> bitmap is updated when the resync completes.
>
> This is because there is no guarentee that resync requests will
> complete in order, and tracking each request individually is
> unnecessarily burdensome.
>
> However there is value in regularly updating the bitmap, so add code
> to periodically pause while all pending sync requests complete, then
> update the bitmap.  Doing this only every few seconds (the same as the
> bitmap update time) does not notciably affect resync performance.
>
> Signed-off-by: Neil Brown <neilb@suse.de>

Hi Neil,

You forgot to export bitmap_cond_end_sync.  Please see the attached patch.

regards,
Mike

------=_Part_18091_21201694.1197317054351
Content-Type: text/x-patch; name=export_bitmap_cond_end_sync.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fa1fkr4p0
Content-Disposition: attachment; filename=export_bitmap_cond_end_sync.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYml0bWFwLmMgYi9kcml2ZXJzL21kL2JpdG1hcC5jCmlu
ZGV4IGYzMWVhNGYuLmI1OTY1MzggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYml0bWFwLmMKKysr
IGIvZHJpdmVycy9tZC9iaXRtYXAuYwpAQCAtMTU2NiwzICsxNTY2LDQgQEAgRVhQT1JUX1NZTUJP
TChiaXRtYXBfc3RhcnRfc3luYyk7CiBFWFBPUlRfU1lNQk9MKGJpdG1hcF9lbmRfc3luYyk7CiBF
WFBPUlRfU1lNQk9MKGJpdG1hcF91bnBsdWcpOwogRVhQT1JUX1NZTUJPTChiaXRtYXBfY2xvc2Vf
c3luYyk7CitFWFBPUlRfU1lNQk9MKGJpdG1hcF9jb25kX2VuZF9zeW5jKTsK
------=_Part_18091_21201694.1197317054351--
