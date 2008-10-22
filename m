Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYJVDis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYJVDis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJVDik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:38:40 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:58248 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751045AbYJVDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:38:40 -0400
Message-ID: <48FEA037.4050007@embeddedalley.com>
Date: Tue, 21 Oct 2008 23:38:31 -0400
From: Matthew Ranostay <mranostay@embeddedalley.com>
Organization: Embedded Alley Solutions Inc
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound: correct bracketing in spdif test
References: <1224646084.5768.9.camel@brick>
In-Reply-To: <1224646084.5768.9.camel@brick>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Noticed by sparse:
> sound/pci/hda/patch_sigmatel.c:1285:43: warning: dubious: !x & y
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  sound/pci/hda/patch_sigmatel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
> index a2ac720..788fdc6 100644
> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -1282,7 +1282,7 @@ static int stac92xx_build_controls(struct hda_codec *codec)
>  			return err;
>  		spec->multiout.share_spdif = 1;
>  	}
> -	if (spec->dig_in_nid && (!spec->gpio_dir & 0x01)) {
> +	if (spec->dig_in_nid && !(spec->gpio_dir & 0x01)) {
>  		err = snd_hda_create_spdif_in_ctls(codec, spec->dig_in_nid);
>  		if (err < 0)
>  			return err;

Thanks for finding this.


Acked-by: Matthew Ranostay <mranostay@embeddedalley.com>
