Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbYANTup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbYANTup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYANTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:50:36 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:47283 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYANTuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P3g6dSj1f2pZsJwbk6aOKwmhrijO85F31LTfQ1fxnfZ1TQiNCLneknofAffU14ZYJyLz7ZjGirWYRXRymWpkE4G1TM+ZnNvPquUvlcc3k2O0hSU38OrJ9HIJMo5DhwS6OBe111ArsGFSRz2Ef+2uOPLKu2Hkl/OBjV8nBaiAhbM=
Message-ID: <478BBD04.1090705@gmail.com>
Date: Mon, 14 Jan 2008 20:50:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] checkstack: parse architecture correctly
References: <20080114111958.58355143@deepthought>
In-Reply-To: <20080114111958.58355143@deepthought>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2008 08:19 PM, Stephen Hemminger wrote:
> The checkstack script wouldn't work because it was picking up the
> newline on the end of the output of uname -m.
> 
> Also, use a standard perl construct to print error message and
> exit with non-zero error code.
> 
> Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>
> 
> --- a/scripts/checkstack.pl	2008-01-14 11:09:09.000000000 -0800
> +++ b/scripts/checkstack.pl	2008-01-14 11:09:51.000000000 -0800
[...]
> -		print("wrong or unknown architecture\n");
> -		exit
> +	    	die "wrong or unknown architecture\"$arch\"\n";

a space before the variable would be good, maybe qq() instead of "" to avoid 
backslashing? Also the \n is reduntant there, otherwise you will loose the 
file+line info.
