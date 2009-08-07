Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbZHGPLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbZHGPLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbZHGPLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:11:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11287 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbZHGPLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:11:32 -0400
X-SpamScore: -13
X-BigFish: VPS-13(z34a4jz1432R98dNzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
X-WSS-ID: 0KO0I6X-01-1A3-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 17:11:02 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: wan wei <onewayforever@gmail.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Rewrite unganged mode code of
 f10_early_channel_count
Message-ID: <20090807151102.GE29900@aftab>
References: <86bb1aef0908062236w1912a909yfa892d40f1776e08@mail.gmail.com>
 <20090807122916.GC29900@aftab>
 <86bb1aef0908070739q6b7fdd60wae9550bb99f658cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86bb1aef0908070739q6b7fdd60wae9550bb99f658cd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Aug 2009 15:11:01.0305 (UTC) FILETIME=[4661FA90:01CA1771]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:39:39PM +0800, wan wei wrote:
> simplify the procedure by checking if there is any dimm  in each channel.
> this patch will fix the bugs such as when there is no dimms  under
> certain node,  two dimms in the same channel, and only one dimm in
> each channel of the node.
> 
> Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>
> ---
>  drivers/edac/amd64_edac.c |   43 ++++++++++---------------------------------
>  1 files changed, 10 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index e2a10bc..acf9cfe 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1200,6 +1200,8 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
>  {
>  	int err = 0, channels = 0;
>  	u32 dbam;
> +	int i, j;
> +	int dbams[] = { DBAM0, DBAM1 };
> 
>  	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
>  	if (err)
> @@ -1232,45 +1234,20 @@ static int f10_early_channel_count(struct
> amd64_pvt *pvt)

Thanks.

patching file drivers/edac/amd64_edac.c
patch: **** malformed patch at line 28: amd64_pvt *pvt)

Your patch is still garbled, I've applied it by hand this time. For the
future, please send a patch privately to yourself first and try applying
it to check whether your mail client mangles it.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

