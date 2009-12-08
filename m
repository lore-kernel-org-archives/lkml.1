Return-Path: <linux-kernel-owner+w=401wt.eu-S966473AbZLHVm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473AbZLHVm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966425AbZLHVmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:42:52 -0500
Received: from kroah.org ([198.145.64.141]:49830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbZLHVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:42:50 -0500
Date: Tue, 8 Dec 2009 13:42:46 -0800
From: Greg KH <greg@kroah.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@kernellabs.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: 2.6.27.40 build error
Message-ID: <20091208214246.GA21857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that the patch below causes a build failure on the
2.6.27.40 kernel.

Michael, should I just drop it, or should I take out the line with the
"capture_transfer_done" in it, as that member is not in the structure in
this kernel version.

thanks,

greg k-h

On Thu, Oct 15, 2009 at 01:14:34AM -0300, Devin Heitmueller wrote:
> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> 
> commit 96fbf771d86a90ff006bc62ca4d4de6474b3de31 upstream.
> 
> Because the counters were not reset when starting up streaming, they would
> be reused from the previous run.  This can result in cases such that when the
> second instance of streaming starts up, the "cnt" variable in
> em28xx_audio_isocirq() can end up being negative, resulting in attempting to
> write to memory before the start of runtime->dma_area (as well as having a
> negative number of bytes to copy).
> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/media/video/em28xx/em28xx-audio.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/drivers/media/video/em28xx/em28xx-audio.c
> +++ b/drivers/media/video/em28xx/em28xx-audio.c
> @@ -365,6 +365,11 @@ static int snd_em28xx_hw_capture_free(st
>  
>  static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
>  {
> +	struct em28xx *dev = snd_pcm_substream_chip(substream);
> +
> +	dev->adev.hwptr_done_capture = 0;
> +	dev->adev.capture_transfer_done = 0;
> +
>  	return 0;
>  }
>  
