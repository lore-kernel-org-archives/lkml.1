Return-Path: <linux-kernel-owner+w=401wt.eu-S936030AbYBCGRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936030AbYBCGRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYBCGRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:17:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50641 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYBCGRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:17:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dmHfoDpjXFBcA6QCWqtR5Llh4bEAiwZvtMlelcOW11I454gWNOJDoXvy6uTlQo9NOifkIDRRW3jQMmLumurUM0WAQ4wOngJAF5Ci5OhJo70D/QMPdjNUO8PrJQ5nBswOd+gYd2erGAdZs0aNU8OCiw9gAYlfy03KbDYji1wXBMs=
Message-ID: <47A55C5E.70305@gmail.com>
Date: Sun, 03 Feb 2008 07:17:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mxser: fix compile warning building without CONFIG_PCI
References: <47A52E20.7000608@cn.fujitsu.com>
In-Reply-To: <47A52E20.7000608@cn.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2008 03:59 AM, Li Zefan wrote:
> When build without CONFIG_PIC, got the following warnings:
> 
> drivers/char/mxser.c: In function 'mxser_init':
> drivers/char/mxser.c:698: warning: unused variable 'devnum'
> drivers/char/mxser.c:698: warning: unused variable 'busnum'
> drivers/char/mxser.c:697: warning: unused variable 'index'
> drivers/char/mxser.c:696: warning: unused variable 'pdev'
> drivers/char/mxser.c:695: warning: unused variable 'n'
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  drivers/char/mxser.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
> index fd0abef..b2cc93d 100644
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -692,10 +692,7 @@ static int mxser_get_PCI_conf(int busnum, int devnum, int board_type, struct mxs
>  
>  static int mxser_init(void)
>  {
> -	int i, m, retval, b, n;
> -	struct pci_dev *pdev = NULL;
> -	int index;
> -	unsigned char busnum, devnum;
> +	int i, m, retval, b;
>  	struct mxser_hwconf hwconf;
>  
>  	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
> @@ -834,10 +831,11 @@ static int mxser_init(void)
>  
>  	/* start finding PCI board here */
>  #ifdef CONFIG_PCI
> -	n = ARRAY_SIZE(mxser_pcibrds) - 1;
> -	index = 0;
>  	b = 0;
> -	while (b < n) {
> +	while (b < ARRAY_SIZE(mxser_pcibrds)-1) {
> +		unsigned char busnum, devnum;
> +		struct pci_dev *pdev;
> +
>  		pdev = pci_get_device(mxser_pcibrds[b].vendor,
>  				mxser_pcibrds[b].device, pdev);
>  		if (pdev == NULL) {

This version of driver is no longer in -mm.
