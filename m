Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZHJOe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZHJOe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZHJOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:34:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:20163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbZHJOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PFSWEsVkig4cc1LTjqm+I0exWc3+lCs/jAQYO4XLlUCaXRlWH3BoSV5dQXmhYtw79m
         kKeLzrylPBZjLHF1V7KAUNs/XF1S9BBtIzUvzNhLDenI+DZ3Lgki0k8JX7eVT6/y3icg
         qcEGxF7qBa/ykJRFrfkeC54bHgAYWMb16CMq8=
Date: Mon, 10 Aug 2009 22:37:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH v2] markup_oops: Use modinfo to avoid confusion with
	underscored module names
Message-ID: <20090810143725.GA7173@hack>
References: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr> <1249895593-23567-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249895593-23567-1-git-send-email-ozan@pardus.org.tr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 12:13:13PM +0300, Ozan Çağlayan wrote:
>When EIP is at a module having an underscore in its name, the current
>code fails to find it because the module filenames has '-' instead of
>'_'. Use modinfo for a better path finding.
>
>Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> scripts/markup_oops.pl |    5 +----
> 1 files changed, 1 insertions(+), 4 deletions(-)
>
>diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
>index 8977401..5f0fcb7 100644
>--- a/scripts/markup_oops.pl
>+++ b/scripts/markup_oops.pl
>@@ -184,10 +184,7 @@ if ($target eq "0") {
> 
> # if it's a module, we need to find the .ko file and calculate a load offset
> if ($module ne "") {
>-	my $dir = dirname($filename);
>-	$dir = $dir . "/";
>-	my $mod = $module . ".ko";
>-	my $modulefile = `find $dir -name $mod | head -1`;
>+	my $modulefile = `modinfo $module | grep '^filename:' | awk '{ print \$2 }'`;
> 	chomp($modulefile);
> 	$filename = $modulefile;
> 	if ($filename eq "") {
>-- 
>1.6.3.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
