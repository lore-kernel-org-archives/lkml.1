Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0BSN7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:59:23 -0500
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:4543 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238Ab0BSN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:59:22 -0500
Date: Fri, 19 Feb 2010 14:59:16 +0100
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] dvb: copy_from_user checks
Message-ID: <20100219135915.GA57188@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <20100218183753.8212.3164.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218183753.8212.3164.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 06:39:16PM +0000, Alan Cox wrote:
> I don't believe the frag count can ever get loaded with a negative value
> even with the -2 but neither the compiler (nor I ;)) can prove it so keep
> us both happy.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> index cb22da5..2cf03e9 100644
> --- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> @@ -1280,7 +1280,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
>  	u8 slot, connection_id;
>  	int status;
>  	u8 fragbuf[HOST_LINK_BUF_SIZE];
> -	int fragpos = 0;
> +	unsigned int fragpos = 0;
>  	int fraglen;
>  	unsigned long timeout;
>  	int written;
> @@ -1308,6 +1308,8 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
>  		fraglen = ca->slot_info[slot].link_buf_size - 2;
>  		if ((count - fragpos) < fraglen)
>  			fraglen = count - fragpos;
> +		if (fraglen < 0)
> +		        fraglen = 0;

If fragpos is unsigned int, then the < fraglen comparison is going to
be unsigned, which is probably not what you want either, is it?

  OG.

