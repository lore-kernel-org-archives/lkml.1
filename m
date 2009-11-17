Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZKQMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZKQMZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZKQMZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:25:24 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:1364 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752209AbZKQMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:25:23 -0500
Message-ID: <4B02961F.8020108@draigBrady.com>
Date: Tue, 17 Nov 2009 12:25:03 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Wagner <daw@cs.berkeley.edu>
Subject: Re: [PATCH] Documentation: Fix NUL termination of strncpy
References: <4B018405.2030408@gmail.com> <4B019F52.50509@gmail.com>
In-Reply-To: <4B019F52.50509@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Ensure the copied strings are NUL terminated.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>> Rationale (please correct me if I'm wrong):
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index 6e25c26..4d71b0e 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -303,7 +303,7 @@ int main(int argc, char *argv[])
>  				err(1, "Invalid rcv buf size\n");
>  			break;
>  		case 'm':
> -			strncpy(cpumask, optarg, sizeof(cpumask));
> +			strncpy(cpumask, optarg, sizeof(cpumask) - 1);

You need to explicitly NUL terminate strncpy():
http://www.pixelbeat.org/programming/gcc/string_buffers.html

cheers,
Pádraig.
