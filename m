Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXFIT1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXFIT1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbXFIT1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:27:04 -0400
Received: from gw.ac.upc.edu ([147.83.30.3]:35558 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbXFIT1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:27:03 -0400
In-Reply-To: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
Date: Sat, 9 Jun 2007 21:26:59 +0200
To: Christian Kujau <lists@nerdbynature.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/06/2007, at 21:22, Christian Kujau wrote:

> Hi,
>
> I noticed that scripts/extract-ikconfig is using /bin/sh in its  
> shebang but when /bin/sh is not a symlink to bash, it breaks with:
> [...]
> @@ -18,8 +18,8 @@ function dump_config {
>      fi
>      end=`$binoffset $file $IKCFG_ED 2>/dev/null`
>
> -    let start="$start + 8"
> -    let size="$end - $start"
> +    start="`expr $start + 8`"
> +    size="`expr $end - $start`"

Wouldn't this be better expressed as:

     start=$(($start + 8))
     size=$(($end - $start))

to avoid invoking a subshell?

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


