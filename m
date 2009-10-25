Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZJYQUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZJYQUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZJYQUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:20:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48548 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbZJYQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:20:19 -0400
X-Sasl-enc: FSiGX4t21t2cBNnUXgJE89+s4msxDwBwjfLULWNMAPS0 1256487622
Date: Sun, 25 Oct 2009 14:20:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: gregkh@suse.de, alan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: cascade needless conditionals
Message-ID: <20091025162019.GA10898@khazad-dum.debian.net>
References: <b8bf37780910250618h3edce547y41a8dd03e4fb4e71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780910250618h3edce547y41a8dd03e4fb4e71@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009, André Goddard Rosa wrote:
>  	if (flags == UPF_SPD_HI)
>  		altbaud = 57600;
> -	if (flags == UPF_SPD_VHI)
> +	else if (flags == UPF_SPD_VHI)
>  		altbaud = 115200;
> -	if (flags == UPF_SPD_SHI)
> +	else if (flags == UPF_SPD_SHI)
>  		altbaud = 230400;
> -	if (flags == UPF_SPD_WARP)
> +	else if (flags == UPF_SPD_WARP)
>  		altbaud = 460800;

This changes code behaviour if more than one bit is set (which might never
happen for all I know...).  You should invert the order of the tests if you
want to make sure it is side-effect-free. 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
