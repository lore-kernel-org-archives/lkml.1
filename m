Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbYIJVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbYIJVQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYIJVQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:16:09 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:61813 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYIJVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=h0N0W4i7jCGXNSoJuNEz88X6FvF1BucL3Ti6pXpoeSQBEtfmclcguXFJt7h2J/Mi0c
         yANTwaJjFBDvXCSQgtaeTcbV99y6ers+KdNpoYDeWQnzORz1KgixCoKxa65/8phHOnsW
         MoecsewG5zwcJ9FohKjqKC8VvseR8Xan0ehs4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Date: Wed, 10 Sep 2008 23:09:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
In-Reply-To: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809102309.34159.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 09 September 2008, Steven Noonan wrote:
> Fixed the warning by initializing 'rc' to zero.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index 994e410..e53c645 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -1492,7 +1492,7 @@ static struct device_attribute *ide_port_attrs[] = {
>  
>  static int ide_sysfs_register_port(ide_hwif_t *hwif)
>  {
> -	int i, rc;
> +	int i, rc = 0;
>  
>  	for (i = 0; ide_port_attrs[i]; i++) {
>  		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);

I recall seeing identical patch before:

	http://article.gmane.org/gmane.linux.ide/33107

Does the existing code really results in gcc warning?

If so we may apply it just to shut-up the broken gcc version...

Thanks,
Bart
