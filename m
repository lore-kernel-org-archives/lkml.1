Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZF2XGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZF2XGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZF2XGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:06:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2721 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZF2XGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:06:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qTxORXSIr/bmfChgfbe+gT/i470iidxHRRro6stK5AIsYBHYPiKemLWP7IH/SoM8a
	10JyH5Bt9/2BQQiK0oY+Q==
MIME-Version: 1.0
In-Reply-To: <20090629211931.GD6611@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz>
	 <20090629123840.1e20f17d.akpm@linux-foundation.org>
	 <a55d774e0906291300u3bb9b491r124f27fdf832b495@mail.gmail.com>
	 <20090629211931.GD6611@elf.ucw.cz>
Date: Mon, 29 Jun 2009 16:06:40 -0700
X-Google-Sender-Auth: 17bdaaccd518e5f1
Message-ID: <404ea8000906291606u600673f3r63a9ac0dfe02eea@mail.gmail.com>
Subject: Re: Framebuffer support for HTC Dream
From: Dima Zavin <dima@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

Thanks for doing the clean up pass, it was long overdue.

>> > So you didn't wrote the code?
>> >
>> >> This adds support for framebuffer on HTC Dream smartphone (aka
>> >> T-Mobile G1, aka ADP1).
>> >>
>> >> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> >> Cc: Brian Swetland <swetland@google.com>
>> >
>> > Someone did.  Are the signoffs and attributions correct and
>> > appropriate?  Should we at least mention the driver's history in the
>> > changelog?

The patch (though it was probably several patches) in our msm tree had
the proper author attribution (Rebecca Schultz Zavin
<rebecca@android.com>), so I think it would make the most sense to
keep that information.

>> > Will it have a maintainer?
>>
>> I did the original quick and dirty version for bringup.  Rebecca took
>> over and (re)wrote the bulk of the driver, getting things stable for
>> production ship of Dream and Sapphire, and Dima is currently adding
>> support for later Qualcomm chipsets (QSD8x50, etc).  Looping them into
>> this discussion.
>
> I can maintain it if noone else steps up. Of course, someone who
> actually knows the hw/has the docs would be preferable.

As Brian mentioned, I'm the last one to touch it here, so I now own
it. I've done a bunch refactoring to add support for the qsd8x50
devices. I'll post those up onto our experimental git tree (hopefully
sometime today), and once this patch goes in, I'll make sure that we
apply cleanly against it. Alternatively, if you like, I can
incorporate your comments into the refactoring work I'm doing, and can
push out the combined patch. In the future though, I'll try to be a
lot more aggressive at sending these out for review earlier so you
don't have to clean up our mess.

Please feel free to CC Rebecca and myself on all the msm_fb related
changes/discussions.

>> It would probably be worth referring to drivers like this as "for
>> Qualcomm MSM/QSD SoCs" or the like, since they do work with a lot of
>> hardware beyond just Dream.
>
> Well, the Dream is why I'm doing it, hence patch title. Of course,
> Kconfig should say 'Qualcomm MSM/QSD SoCs', too.

I second the request that the patches for qualcomm msm7k/qsd8k generic
support would have descriptions that refer to them as such, since the
htc dream specific code is only in the board files in
arch/arm/mach-msm. Note that the HTC Magic (aka the Ion, myTouch 3G,
etc.) uses the exact same fb code (i.e. it's also using the msm7201a
chipset). Mentioning in the body of the patch message that this is the
chipset used in the HTC Dream definitely makes sense, but the main
description should really refer to these as adding generic msm7k
support.

Thanks again for pushing this stuff up. Your help is much appreciated.

--Dima

> Sorry for world record in checkpatch warnings. I checked .c files, but
> somehow forgot about .h files.
>                                                                        Pavel
>
> ---
>
> Fix checkpatch warnings in HTC Dream display driver.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/drivers/video/msm/mddi_hw.h b/drivers/video/msm/mddi_hw.h
> index 0cb55eb..45cc01f 100644
> --- a/drivers/video/msm/mddi_hw.h
> +++ b/drivers/video/msm/mddi_hw.h
> @@ -199,39 +199,39 @@ struct __attribute__((packed)) mddi_video_stream {
>        uint16_t client_id; /* 0 */
>
>        uint16_t video_data_format_descriptor;
> -       /* format of each pixel in the Pixel Data in the present stream in the
> -        * present packet.
> -        * If bits [15:13] = 000 monochrome
> -        * If bits [15:13] = 001 color pixels (palette).
> -        * If bits [15:13] = 010 color pixels in raw RGB
> -        * If bits [15:13] = 011 data in 4:2:2 Y Cb Cr format
> -        * If bits [15:13] = 100 Bayer pixels
> -        */
> +/* format of each pixel in the Pixel Data in the present stream in the
> + * present packet.
> + * If bits [15:13] = 000 monochrome
> + * If bits [15:13] = 001 color pixels (palette).
> + * If bits [15:13] = 010 color pixels in raw RGB
> + * If bits [15:13] = 011 data in 4:2:2 Y Cb Cr format
> + * If bits [15:13] = 100 Bayer pixels
> + */
>
>        uint16_t pixel_data_attributes;
> -       /* interpreted as follows:
> -        * Bits [1:0] = 11  pixel data is displayed to both eyes
> -        * Bits [1:0] = 10  pixel data is routed to the left eye only.
> -        * Bits [1:0] = 01  pixel data is routed to the right eye only.
> -        * Bits [1:0] = 00  pixel data is routed to the alternate display.
> -        * Bit 2 is 0  Pixel Data is in the standard progressive format.
> -        * Bit 2 is 1  Pixel Data is in interlace format.
> -        * Bit 3 is 0  Pixel Data is in the standard progressive format.
> -        * Bit 3 is 1  Pixel Data is in alternate pixel format.
> -        * Bit 4 is 0  Pixel Data is to or from the display frame buffer.
> -        * Bit 4 is 1  Pixel Data is to or from the camera.
> -        * Bit 5 is 0  pixel data contains the next consecutive row of pixels.
> -        * Bit 5 is 1  X Left Edge, Y Top Edge, X Right Edge, Y Bottom Edge,
> -        *             X Start, and Y Start parameters are not defined and
> -        *             shall be ignored by the client.
> -        * Bits [7:6] = 01  Pixel data is written to the offline image buffer.
> -        * Bits [7:6] = 00  Pixel data is written to the buffer to refresh display.
> -        * Bits [7:6] = 11  Pixel data is written to all image buffers.
> -        * Bits [7:6] = 10  Invalid. Reserved for future use.
> -        * Bits 8 through 11 alternate display number.
> -        * Bits 12 through 14 are reserved for future use and shall be set to zero.
> -        * Bit 15 is 1 the row of pixels is the last row of pixels in a frame.
> -        */
> +/* interpreted as follows:
> + * Bits [1:0] = 11  pixel data is displayed to both eyes
> + * Bits [1:0] = 10  pixel data is routed to the left eye only.
> + * Bits [1:0] = 01  pixel data is routed to the right eye only.
> + * Bits [1:0] = 00  pixel data is routed to the alternate display.
> + * Bit 2 is 0  Pixel Data is in the standard progressive format.
> + * Bit 2 is 1  Pixel Data is in interlace format.
> + * Bit 3 is 0  Pixel Data is in the standard progressive format.
> + * Bit 3 is 1  Pixel Data is in alternate pixel format.
> + * Bit 4 is 0  Pixel Data is to or from the display frame buffer.
> + * Bit 4 is 1  Pixel Data is to or from the camera.
> + * Bit 5 is 0  pixel data contains the next consecutive row of pixels.
> + * Bit 5 is 1  X Left Edge, Y Top Edge, X Right Edge, Y Bottom Edge,
> + *             X Start, and Y Start parameters are not defined and
> + *             shall be ignored by the client.
> + * Bits [7:6] = 01  Pixel data is written to the offline image buffer.
> + * Bits [7:6] = 00  Pixel data is written to the buffer to refresh display.
> + * Bits [7:6] = 11  Pixel data is written to all image buffers.
> + * Bits [7:6] = 10  Invalid. Reserved for future use.
> + * Bits 8 through 11 alternate display number.
> + * Bits 12 through 14 are reserved for future use and shall be set to zero.
> + * Bit 15 is 1 the row of pixels is the last row of pixels in a frame.
> + */
>
>        uint16_t x_left_edge;
>        uint16_t y_top_edge;
> @@ -239,17 +239,19 @@ struct __attribute__((packed)) mddi_video_stream {
>
>        uint16_t x_right_edge;
>        uint16_t y_bottom_edge;
> -       /*  X,Y coordinate of the bottom right edge of the window being updated. */
> +       /* X,Y coordinate of the bottom right edge of the window being
> +        * updated. */
>
>        uint16_t x_start;
>        uint16_t y_start;
> -       /*  (X Start, Y Start) is the first pixel in the Pixel Data field below. */
> +       /* (X Start, Y Start) is the first pixel in the Pixel Data field
> +        * below. */
>
>        uint16_t pixel_count;
> -       /*  number of pixels in the Pixel Data field below. */
> +       /* number of pixels in the Pixel Data field below. */
>
>        uint16_t parameter_CRC;
> -       /*  16-bit CRC of all bytes from the Packet Length to the Pixel Count. */
> +       /* 16-bit CRC of all bytes from the Packet Length to the Pixel Count. */
>
>        uint16_t reserved;
>        /* 16-bit variable to make structure align on 4 byte boundary */
> diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
> index d78dafa..4e3deb4 100644
> --- a/drivers/video/msm/mdp_hw.h
> +++ b/drivers/video/msm/mdp_hw.h
> @@ -20,7 +20,7 @@
>
>  struct mdp_info {
>        struct mdp_device mdp_dev;
> -       char* __iomem base;
> +       char * __iomem base;
>        int irq;
>  };
>  struct mdp_blit_req;
> @@ -32,149 +32,149 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>  #define mdp_writel(mdp, value, offset) writel(value, mdp->base + offset)
>  #define mdp_readl(mdp, offset) readl(mdp->base + offset)
>
> -#define MDP_SYNC_CONFIG_0                ( 0x00000)
> -#define MDP_SYNC_CONFIG_1                ( 0x00004)
> -#define MDP_SYNC_CONFIG_2                ( 0x00008)
> -#define MDP_SYNC_STATUS_0                ( 0x0000c)
> -#define MDP_SYNC_STATUS_1                ( 0x00010)
> -#define MDP_SYNC_STATUS_2                ( 0x00014)
> -#define MDP_SYNC_THRESH_0                ( 0x00018)
> -#define MDP_SYNC_THRESH_1                ( 0x0001c)
> -#define MDP_INTR_ENABLE                  ( 0x00020)
> -#define MDP_INTR_STATUS                  ( 0x00024)
> -#define MDP_INTR_CLEAR                   ( 0x00028)
> -#define MDP_DISPLAY0_START               ( 0x00030)
> -#define MDP_DISPLAY1_START               ( 0x00034)
> -#define MDP_DISPLAY_STATUS               ( 0x00038)
> -#define MDP_EBI2_LCD0                    ( 0x0003c)
> -#define MDP_EBI2_LCD1                    ( 0x00040)
> -#define MDP_DISPLAY0_ADDR                ( 0x00054)
> -#define MDP_DISPLAY1_ADDR                ( 0x00058)
> -#define MDP_EBI2_PORTMAP_MODE            ( 0x0005c)
> -#define MDP_MODE                         ( 0x00060)
> -#define MDP_TV_OUT_STATUS                ( 0x00064)
> -#define MDP_HW_VERSION                   ( 0x00070)
> -#define MDP_SW_RESET                     ( 0x00074)
> -#define MDP_AXI_ERROR_MASTER_STOP        ( 0x00078)
> -#define MDP_SEL_CLK_OR_HCLK_TEST_BUS     ( 0x0007c)
> -#define MDP_PRIMARY_VSYNC_OUT_CTRL       ( 0x00080)
> -#define MDP_SECONDARY_VSYNC_OUT_CTRL     ( 0x00084)
> -#define MDP_EXTERNAL_VSYNC_OUT_CTRL      ( 0x00088)
> -#define MDP_VSYNC_CTRL                   ( 0x0008c)
> -#define MDP_CGC_EN                       ( 0x00100)
> -#define MDP_CMD_STATUS                   ( 0x10008)
> -#define MDP_PROFILE_EN                   ( 0x10010)
> -#define MDP_PROFILE_COUNT                ( 0x10014)
> -#define MDP_DMA_START                    ( 0x10044)
> -#define MDP_FULL_BYPASS_WORD0            ( 0x10100)
> -#define MDP_FULL_BYPASS_WORD1            ( 0x10104)
> -#define MDP_COMMAND_CONFIG               ( 0x10104)
> -#define MDP_FULL_BYPASS_WORD2            ( 0x10108)
> -#define MDP_FULL_BYPASS_WORD3            ( 0x1010c)
> -#define MDP_FULL_BYPASS_WORD4            ( 0x10110)
> -#define MDP_FULL_BYPASS_WORD6            ( 0x10118)
> -#define MDP_FULL_BYPASS_WORD7            ( 0x1011c)
> -#define MDP_FULL_BYPASS_WORD8            ( 0x10120)
> -#define MDP_FULL_BYPASS_WORD9            ( 0x10124)
> -#define MDP_PPP_SOURCE_CONFIG            ( 0x10124)
> -#define MDP_FULL_BYPASS_WORD10           ( 0x10128)
> -#define MDP_FULL_BYPASS_WORD11           ( 0x1012c)
> -#define MDP_FULL_BYPASS_WORD12           ( 0x10130)
> -#define MDP_FULL_BYPASS_WORD13           ( 0x10134)
> -#define MDP_FULL_BYPASS_WORD14           ( 0x10138)
> -#define MDP_PPP_OPERATION_CONFIG         ( 0x10138)
> -#define MDP_FULL_BYPASS_WORD15           ( 0x1013c)
> -#define MDP_FULL_BYPASS_WORD16           ( 0x10140)
> -#define MDP_FULL_BYPASS_WORD17           ( 0x10144)
> -#define MDP_FULL_BYPASS_WORD18           ( 0x10148)
> -#define MDP_FULL_BYPASS_WORD19           ( 0x1014c)
> -#define MDP_FULL_BYPASS_WORD20           ( 0x10150)
> -#define MDP_PPP_DESTINATION_CONFIG       ( 0x10150)
> -#define MDP_FULL_BYPASS_WORD21           ( 0x10154)
> -#define MDP_FULL_BYPASS_WORD22           ( 0x10158)
> -#define MDP_FULL_BYPASS_WORD23           ( 0x1015c)
> -#define MDP_FULL_BYPASS_WORD24           ( 0x10160)
> -#define MDP_FULL_BYPASS_WORD25           ( 0x10164)
> -#define MDP_FULL_BYPASS_WORD26           ( 0x10168)
> -#define MDP_FULL_BYPASS_WORD27           ( 0x1016c)
> -#define MDP_FULL_BYPASS_WORD29           ( 0x10174)
> -#define MDP_FULL_BYPASS_WORD30           ( 0x10178)
> -#define MDP_FULL_BYPASS_WORD31           ( 0x1017c)
> -#define MDP_FULL_BYPASS_WORD32           ( 0x10180)
> -#define MDP_DMA_CONFIG                   ( 0x10180)
> -#define MDP_FULL_BYPASS_WORD33           ( 0x10184)
> -#define MDP_FULL_BYPASS_WORD34           ( 0x10188)
> -#define MDP_FULL_BYPASS_WORD35           ( 0x1018c)
> -#define MDP_FULL_BYPASS_WORD37           ( 0x10194)
> -#define MDP_FULL_BYPASS_WORD39           ( 0x1019c)
> -#define MDP_FULL_BYPASS_WORD40           ( 0x101a0)
> -#define MDP_FULL_BYPASS_WORD41           ( 0x101a4)
> -#define MDP_FULL_BYPASS_WORD43           ( 0x101ac)
> -#define MDP_FULL_BYPASS_WORD46           ( 0x101b8)
> -#define MDP_FULL_BYPASS_WORD47           ( 0x101bc)
> -#define MDP_FULL_BYPASS_WORD48           ( 0x101c0)
> -#define MDP_FULL_BYPASS_WORD49           ( 0x101c4)
> -#define MDP_FULL_BYPASS_WORD50           ( 0x101c8)
> -#define MDP_FULL_BYPASS_WORD51           ( 0x101cc)
> -#define MDP_FULL_BYPASS_WORD52           ( 0x101d0)
> -#define MDP_FULL_BYPASS_WORD53           ( 0x101d4)
> -#define MDP_FULL_BYPASS_WORD54           ( 0x101d8)
> -#define MDP_FULL_BYPASS_WORD55           ( 0x101dc)
> -#define MDP_FULL_BYPASS_WORD56           ( 0x101e0)
> -#define MDP_FULL_BYPASS_WORD57           ( 0x101e4)
> -#define MDP_FULL_BYPASS_WORD58           ( 0x101e8)
> -#define MDP_FULL_BYPASS_WORD59           ( 0x101ec)
> -#define MDP_FULL_BYPASS_WORD60           ( 0x101f0)
> -#define MDP_VSYNC_THRESHOLD              ( 0x101f0)
> -#define MDP_FULL_BYPASS_WORD61           ( 0x101f4)
> -#define MDP_FULL_BYPASS_WORD62           ( 0x101f8)
> -#define MDP_FULL_BYPASS_WORD63           ( 0x101fc)
> -#define MDP_TFETCH_TEST_MODE             ( 0x20004)
> -#define MDP_TFETCH_STATUS                ( 0x20008)
> -#define MDP_TFETCH_TILE_COUNT            ( 0x20010)
> -#define MDP_TFETCH_FETCH_COUNT           ( 0x20014)
> -#define MDP_TFETCH_CONSTANT_COLOR        ( 0x20040)
> -#define MDP_CSC_BYPASS                   ( 0x40004)
> -#define MDP_SCALE_COEFF_LSB              ( 0x5fffc)
> -#define MDP_TV_OUT_CTL                   ( 0xc0000)
> -#define MDP_TV_OUT_FIR_COEFF             ( 0xc0004)
> -#define MDP_TV_OUT_BUF_ADDR              ( 0xc0008)
> -#define MDP_TV_OUT_CC_DATA               ( 0xc000c)
> -#define MDP_TV_OUT_SOBEL                 ( 0xc0010)
> -#define MDP_TV_OUT_Y_CLAMP               ( 0xc0018)
> -#define MDP_TV_OUT_CB_CLAMP              ( 0xc001c)
> -#define MDP_TV_OUT_CR_CLAMP              ( 0xc0020)
> -#define MDP_TEST_MODE_CLK                ( 0xd0000)
> -#define MDP_TEST_MISR_RESET_CLK          ( 0xd0004)
> -#define MDP_TEST_EXPORT_MISR_CLK         ( 0xd0008)
> -#define MDP_TEST_MISR_CURR_VAL_CLK       ( 0xd000c)
> -#define MDP_TEST_MODE_HCLK               ( 0xd0100)
> -#define MDP_TEST_MISR_RESET_HCLK         ( 0xd0104)
> -#define MDP_TEST_EXPORT_MISR_HCLK        ( 0xd0108)
> -#define MDP_TEST_MISR_CURR_VAL_HCLK      ( 0xd010c)
> -#define MDP_TEST_MODE_DCLK               ( 0xd0200)
> -#define MDP_TEST_MISR_RESET_DCLK         ( 0xd0204)
> -#define MDP_TEST_EXPORT_MISR_DCLK        ( 0xd0208)
> -#define MDP_TEST_MISR_CURR_VAL_DCLK      ( 0xd020c)
> -#define MDP_TEST_CAPTURED_DCLK           ( 0xd0210)
> -#define MDP_TEST_MISR_CAPT_VAL_DCLK      ( 0xd0214)
> -#define MDP_LCDC_CTL                     ( 0xe0000)
> -#define MDP_LCDC_HSYNC_CTL               ( 0xe0004)
> -#define MDP_LCDC_VSYNC_CTL               ( 0xe0008)
> -#define MDP_LCDC_ACTIVE_HCTL             ( 0xe000c)
> -#define MDP_LCDC_ACTIVE_VCTL             ( 0xe0010)
> -#define MDP_LCDC_BORDER_CLR              ( 0xe0014)
> -#define MDP_LCDC_H_BLANK                 ( 0xe0018)
> -#define MDP_LCDC_V_BLANK                 ( 0xe001c)
> -#define MDP_LCDC_UNDERFLOW_CLR           ( 0xe0020)
> -#define MDP_LCDC_HSYNC_SKEW              ( 0xe0024)
> -#define MDP_LCDC_TEST_CTL                ( 0xe0028)
> -#define MDP_LCDC_LINE_IRQ                ( 0xe002c)
> -#define MDP_LCDC_CTL_POLARITY            ( 0xe0030)
> -#define MDP_LCDC_DMA_CONFIG              ( 0xe1000)
> -#define MDP_LCDC_DMA_SIZE                ( 0xe1004)
> -#define MDP_LCDC_DMA_IBUF_ADDR           ( 0xe1008)
> -#define MDP_LCDC_DMA_IBUF_Y_STRIDE       ( 0xe100c)
> +#define MDP_SYNC_CONFIG_0                (0x00000)
> +#define MDP_SYNC_CONFIG_1                (0x00004)
> +#define MDP_SYNC_CONFIG_2                (0x00008)
> +#define MDP_SYNC_STATUS_0                (0x0000c)
> +#define MDP_SYNC_STATUS_1                (0x00010)
> +#define MDP_SYNC_STATUS_2                (0x00014)
> +#define MDP_SYNC_THRESH_0                (0x00018)
> +#define MDP_SYNC_THRESH_1                (0x0001c)
> +#define MDP_INTR_ENABLE                  (0x00020)
> +#define MDP_INTR_STATUS                  (0x00024)
> +#define MDP_INTR_CLEAR                   (0x00028)
> +#define MDP_DISPLAY0_START               (0x00030)
> +#define MDP_DISPLAY1_START               (0x00034)
> +#define MDP_DISPLAY_STATUS               (0x00038)
> +#define MDP_EBI2_LCD0                    (0x0003c)
> +#define MDP_EBI2_LCD1                    (0x00040)
> +#define MDP_DISPLAY0_ADDR                (0x00054)
> +#define MDP_DISPLAY1_ADDR                (0x00058)
> +#define MDP_EBI2_PORTMAP_MODE            (0x0005c)
> +#define MDP_MODE                         (0x00060)
> +#define MDP_TV_OUT_STATUS                (0x00064)
> +#define MDP_HW_VERSION                   (0x00070)
> +#define MDP_SW_RESET                     (0x00074)
> +#define MDP_AXI_ERROR_MASTER_STOP        (0x00078)
> +#define MDP_SEL_CLK_OR_HCLK_TEST_BUS     (0x0007c)
> +#define MDP_PRIMARY_VSYNC_OUT_CTRL       (0x00080)
> +#define MDP_SECONDARY_VSYNC_OUT_CTRL     (0x00084)
> +#define MDP_EXTERNAL_VSYNC_OUT_CTRL      (0x00088)
> +#define MDP_VSYNC_CTRL                   (0x0008c)
> +#define MDP_CGC_EN                       (0x00100)
> +#define MDP_CMD_STATUS                   (0x10008)
> +#define MDP_PROFILE_EN                   (0x10010)
> +#define MDP_PROFILE_COUNT                (0x10014)
> +#define MDP_DMA_START                    (0x10044)
> +#define MDP_FULL_BYPASS_WORD0            (0x10100)
> +#define MDP_FULL_BYPASS_WORD1            (0x10104)
> +#define MDP_COMMAND_CONFIG               (0x10104)
> +#define MDP_FULL_BYPASS_WORD2            (0x10108)
> +#define MDP_FULL_BYPASS_WORD3            (0x1010c)
> +#define MDP_FULL_BYPASS_WORD4            (0x10110)
> +#define MDP_FULL_BYPASS_WORD6            (0x10118)
> +#define MDP_FULL_BYPASS_WORD7            (0x1011c)
> +#define MDP_FULL_BYPASS_WORD8            (0x10120)
> +#define MDP_FULL_BYPASS_WORD9            (0x10124)
> +#define MDP_PPP_SOURCE_CONFIG            (0x10124)
> +#define MDP_FULL_BYPASS_WORD10           (0x10128)
> +#define MDP_FULL_BYPASS_WORD11           (0x1012c)
> +#define MDP_FULL_BYPASS_WORD12           (0x10130)
> +#define MDP_FULL_BYPASS_WORD13           (0x10134)
> +#define MDP_FULL_BYPASS_WORD14           (0x10138)
> +#define MDP_PPP_OPERATION_CONFIG         (0x10138)
> +#define MDP_FULL_BYPASS_WORD15           (0x1013c)
> +#define MDP_FULL_BYPASS_WORD16           (0x10140)
> +#define MDP_FULL_BYPASS_WORD17           (0x10144)
> +#define MDP_FULL_BYPASS_WORD18           (0x10148)
> +#define MDP_FULL_BYPASS_WORD19           (0x1014c)
> +#define MDP_FULL_BYPASS_WORD20           (0x10150)
> +#define MDP_PPP_DESTINATION_CONFIG       (0x10150)
> +#define MDP_FULL_BYPASS_WORD21           (0x10154)
> +#define MDP_FULL_BYPASS_WORD22           (0x10158)
> +#define MDP_FULL_BYPASS_WORD23           (0x1015c)
> +#define MDP_FULL_BYPASS_WORD24           (0x10160)
> +#define MDP_FULL_BYPASS_WORD25           (0x10164)
> +#define MDP_FULL_BYPASS_WORD26           (0x10168)
> +#define MDP_FULL_BYPASS_WORD27           (0x1016c)
> +#define MDP_FULL_BYPASS_WORD29           (0x10174)
> +#define MDP_FULL_BYPASS_WORD30           (0x10178)
> +#define MDP_FULL_BYPASS_WORD31           (0x1017c)
> +#define MDP_FULL_BYPASS_WORD32           (0x10180)
> +#define MDP_DMA_CONFIG                   (0x10180)
> +#define MDP_FULL_BYPASS_WORD33           (0x10184)
> +#define MDP_FULL_BYPASS_WORD34           (0x10188)
> +#define MDP_FULL_BYPASS_WORD35           (0x1018c)
> +#define MDP_FULL_BYPASS_WORD37           (0x10194)
> +#define MDP_FULL_BYPASS_WORD39           (0x1019c)
> +#define MDP_FULL_BYPASS_WORD40           (0x101a0)
> +#define MDP_FULL_BYPASS_WORD41           (0x101a4)
> +#define MDP_FULL_BYPASS_WORD43           (0x101ac)
> +#define MDP_FULL_BYPASS_WORD46           (0x101b8)
> +#define MDP_FULL_BYPASS_WORD47           (0x101bc)
> +#define MDP_FULL_BYPASS_WORD48           (0x101c0)
> +#define MDP_FULL_BYPASS_WORD49           (0x101c4)
> +#define MDP_FULL_BYPASS_WORD50           (0x101c8)
> +#define MDP_FULL_BYPASS_WORD51           (0x101cc)
> +#define MDP_FULL_BYPASS_WORD52           (0x101d0)
> +#define MDP_FULL_BYPASS_WORD53           (0x101d4)
> +#define MDP_FULL_BYPASS_WORD54           (0x101d8)
> +#define MDP_FULL_BYPASS_WORD55           (0x101dc)
> +#define MDP_FULL_BYPASS_WORD56           (0x101e0)
> +#define MDP_FULL_BYPASS_WORD57           (0x101e4)
> +#define MDP_FULL_BYPASS_WORD58           (0x101e8)
> +#define MDP_FULL_BYPASS_WORD59           (0x101ec)
> +#define MDP_FULL_BYPASS_WORD60           (0x101f0)
> +#define MDP_VSYNC_THRESHOLD              (0x101f0)
> +#define MDP_FULL_BYPASS_WORD61           (0x101f4)
> +#define MDP_FULL_BYPASS_WORD62           (0x101f8)
> +#define MDP_FULL_BYPASS_WORD63           (0x101fc)
> +#define MDP_TFETCH_TEST_MODE             (0x20004)
> +#define MDP_TFETCH_STATUS                (0x20008)
> +#define MDP_TFETCH_TILE_COUNT            (0x20010)
> +#define MDP_TFETCH_FETCH_COUNT           (0x20014)
> +#define MDP_TFETCH_CONSTANT_COLOR        (0x20040)
> +#define MDP_CSC_BYPASS                   (0x40004)
> +#define MDP_SCALE_COEFF_LSB              (0x5fffc)
> +#define MDP_TV_OUT_CTL                   (0xc0000)
> +#define MDP_TV_OUT_FIR_COEFF             (0xc0004)
> +#define MDP_TV_OUT_BUF_ADDR              (0xc0008)
> +#define MDP_TV_OUT_CC_DATA               (0xc000c)
> +#define MDP_TV_OUT_SOBEL                 (0xc0010)
> +#define MDP_TV_OUT_Y_CLAMP               (0xc0018)
> +#define MDP_TV_OUT_CB_CLAMP              (0xc001c)
> +#define MDP_TV_OUT_CR_CLAMP              (0xc0020)
> +#define MDP_TEST_MODE_CLK                (0xd0000)
> +#define MDP_TEST_MISR_RESET_CLK          (0xd0004)
> +#define MDP_TEST_EXPORT_MISR_CLK         (0xd0008)
> +#define MDP_TEST_MISR_CURR_VAL_CLK       (0xd000c)
> +#define MDP_TEST_MODE_HCLK               (0xd0100)
> +#define MDP_TEST_MISR_RESET_HCLK         (0xd0104)
> +#define MDP_TEST_EXPORT_MISR_HCLK        (0xd0108)
> +#define MDP_TEST_MISR_CURR_VAL_HCLK      (0xd010c)
> +#define MDP_TEST_MODE_DCLK               (0xd0200)
> +#define MDP_TEST_MISR_RESET_DCLK         (0xd0204)
> +#define MDP_TEST_EXPORT_MISR_DCLK        (0xd0208)
> +#define MDP_TEST_MISR_CURR_VAL_DCLK      (0xd020c)
> +#define MDP_TEST_CAPTURED_DCLK           (0xd0210)
> +#define MDP_TEST_MISR_CAPT_VAL_DCLK      (0xd0214)
> +#define MDP_LCDC_CTL                     (0xe0000)
> +#define MDP_LCDC_HSYNC_CTL               (0xe0004)
> +#define MDP_LCDC_VSYNC_CTL               (0xe0008)
> +#define MDP_LCDC_ACTIVE_HCTL             (0xe000c)
> +#define MDP_LCDC_ACTIVE_VCTL             (0xe0010)
> +#define MDP_LCDC_BORDER_CLR              (0xe0014)
> +#define MDP_LCDC_H_BLANK                 (0xe0018)
> +#define MDP_LCDC_V_BLANK                 (0xe001c)
> +#define MDP_LCDC_UNDERFLOW_CLR           (0xe0020)
> +#define MDP_LCDC_HSYNC_SKEW              (0xe0024)
> +#define MDP_LCDC_TEST_CTL                (0xe0028)
> +#define MDP_LCDC_LINE_IRQ                (0xe002c)
> +#define MDP_LCDC_CTL_POLARITY            (0xe0030)
> +#define MDP_LCDC_DMA_CONFIG              (0xe1000)
> +#define MDP_LCDC_DMA_SIZE                (0xe1004)
> +#define MDP_LCDC_DMA_IBUF_ADDR           (0xe1008)
> +#define MDP_LCDC_DMA_IBUF_Y_STRIDE       (0xe100c)
>
>
>  #define MDP_DMA2_TERM 0x1
> @@ -246,11 +246,11 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>  /* MDP_VSYNC_CTRL */
>  #define DISP0_VSYNC_MAP_VSYNC0 0
>  #define DISP0_VSYNC_MAP_VSYNC1 (1<<0)
> -#define DISP0_VSYNC_MAP_VSYNC2 (1<<0)|(1<<1)
> +#define DISP0_VSYNC_MAP_VSYNC2 ((1<<0)|(1<<1))
>
>  #define DISP1_VSYNC_MAP_VSYNC0 0
>  #define DISP1_VSYNC_MAP_VSYNC1 (1<<2)
> -#define DISP1_VSYNC_MAP_VSYNC2 (1<<2)|(1<<3)
> +#define DISP1_VSYNC_MAP_VSYNC2 ((1<<2)|(1<<3))
>
>  #define PRIMARY_LCD_SYNC_EN (1<<4)
>  #define PRIMARY_LCD_SYNC_DISABLE 0
> @@ -368,7 +368,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>  #define PPP_OP_BG_CHROMA_RGB 0
>  #define PPP_OP_BG_CHROMA_H2V1 (1<<25)
>  #define PPP_OP_BG_CHROMA_H1V2 (1<<26)
> -#define PPP_OP_BG_CHROMA_420 (1<<25)|(1<<26)
> +#define PPP_OP_BG_CHROMA_420 ((1<<25)|(1<<26))
>  #define PPP_OP_BG_CHROMA_SITE_COSITE 0
>  #define PPP_OP_BG_CHROMA_SITE_OFFSITE (1<<27)
>
> @@ -417,25 +417,25 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>  #define PPP_DST_MDDI_EXTERNAL (1<<22)
>
>  /* image configurations by image type */
> -#define PPP_CFG_MDP_RGB_565(dir)       PPP_##dir##_C2R_5BIT | \
> +#define PPP_CFG_MDP_RGB_565(dir)       (PPP_##dir##_C2R_5BIT | \
>                                        PPP_##dir##_C0G_6BIT | \
>                                        PPP_##dir##_C1B_5BIT | \
>                                        PPP_##dir##_BPP_2BYTES | \
>                                        PPP_##dir##_INTERLVD_3COMPONENTS | \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB | \
> -                                       PPP_##dir##_PLANE_INTERLVD
> +                                       PPP_##dir##_PLANE_INTERLVD)
>
> -#define PPP_CFG_MDP_RGB_888(dir)       PPP_##dir##_C2R_8BIT | \
> +#define PPP_CFG_MDP_RGB_888(dir)       (PPP_##dir##_C2R_8BIT | \
>                                        PPP_##dir##_C0G_8BIT | \
>                                        PPP_##dir##_C1B_8BIT | \
>                                        PPP_##dir##_BPP_3BYTES | \
>                                        PPP_##dir##_INTERLVD_3COMPONENTS | \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB | \
> -                                       PPP_##dir##_PLANE_INTERLVD
> +                                       PPP_##dir##_PLANE_INTERLVD)
>
> -#define PPP_CFG_MDP_ARGB_8888(dir)     PPP_##dir##_C2R_8BIT | \
> +#define PPP_CFG_MDP_ARGB_8888(dir)     (PPP_##dir##_C2R_8BIT | \
>                                        PPP_##dir##_C0G_8BIT | \
>                                        PPP_##dir##_C1B_8BIT | \
>                                        PPP_##dir##_C3A_8BIT | \
> @@ -444,13 +444,13 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>                                        PPP_##dir##_INTERLVD_4COMPONENTS | \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB | \
> -                                       PPP_##dir##_PLANE_INTERLVD
> +                                       PPP_##dir##_PLANE_INTERLVD)
>
>  #define PPP_CFG_MDP_XRGB_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
>  #define PPP_CFG_MDP_RGBA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
>  #define PPP_CFG_MDP_BGRA_8888(dir) PPP_CFG_MDP_ARGB_8888(dir)
>
> -#define PPP_CFG_MDP_Y_CBCR_H2V2(dir)   PPP_##dir##_C2R_8BIT | \
> +#define PPP_CFG_MDP_Y_CBCR_H2V2(dir)   (PPP_##dir##_C2R_8BIT | \
>                                        PPP_##dir##_C0G_8BIT | \
>                                        PPP_##dir##_C1B_8BIT | \
>                                        PPP_##dir##_C3A_8BIT | \
> @@ -458,11 +458,11 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>                                        PPP_##dir##_INTERLVD_2COMPONENTS | \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB | \
> -                                       PPP_##dir##_PLANE_PSEUDOPLNR
> +                                       PPP_##dir##_PLANE_PSEUDOPLNR)
>
>  #define PPP_CFG_MDP_Y_CRCB_H2V2(dir)   PPP_CFG_MDP_Y_CBCR_H2V2(dir)
>
> -#define PPP_CFG_MDP_YCRYCB_H2V1(dir)   PPP_##dir##_C2R_8BIT | \
> +#define PPP_CFG_MDP_YCRYCB_H2V1(dir)   (PPP_##dir##_C2R_8BIT | \
>                                        PPP_##dir##_C0G_8BIT | \
>                                        PPP_##dir##_C1B_8BIT | \
>                                        PPP_##dir##_C3A_8BIT | \
> @@ -470,9 +470,9 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>                                        PPP_##dir##_INTERLVD_4COMPONENTS | \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB |\
> -                                       PPP_##dir##_PLANE_INTERLVD
> +                                       PPP_##dir##_PLANE_INTERLVD)
>
> -#define PPP_CFG_MDP_Y_CBCR_H2V1(dir)   PPP_##dir##_C2R_8BIT | \
> +#define PPP_CFG_MDP_Y_CBCR_H2V1(dir)   (PPP_##dir##_C2R_8BIT | \
>                                        PPP_##dir##_C0G_8BIT | \
>                                        PPP_##dir##_C1B_8BIT | \
>                                        PPP_##dir##_C3A_8BIT | \
> @@ -480,7 +480,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>                                        PPP_##dir##_INTERLVD_2COMPONENTS |  \
>                                        PPP_##dir##_PACK_TIGHT | \
>                                        PPP_##dir##_PACK_ALIGN_LSB | \
> -                                       PPP_##dir##_PLANE_PSEUDOPLNR
> +                                       PPP_##dir##_PLANE_PSEUDOPLNR)
>
>  #define PPP_CFG_MDP_Y_CRCB_H2V1(dir)   PPP_CFG_MDP_Y_CBCR_H2V1(dir)
>
> @@ -549,7 +549,7 @@ int mdp_ppp_blit(const struct mdp_info *mdp, struct mdp_blit_req *req,
>                     (img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
>                     (img == MDP_XRGB_8888) | (img == MDP_BGRA_8888))
>  #define HAS_ALPHA(img) ((img == MDP_ARGB_8888) | (img == MDP_RGBA_8888) | \
> -                       (img == MDP_BGRA_8888))
> +                       (img == MDP_BGRA_8888))
>
>  #define IS_PSEUDOPLNR(img) ((img == MDP_Y_CRCB_H2V2) | \
>                            (img == MDP_Y_CBCR_H2V2) | \
> diff --git a/drivers/video/msm/mdp_scale_tables.h b/drivers/video/msm/mdp_scale_tables.h
> index 4e19a25..34077b1 100644
> --- a/drivers/video/msm/mdp_scale_tables.h
> +++ b/drivers/video/msm/mdp_scale_tables.h
> @@ -31,8 +31,8 @@ enum {
>        MDP_DOWNSCALE_MAX,
>  };
>
> -extern struct mdp_table_entry* mdp_downscale_x_table[MDP_DOWNSCALE_MAX];
> -extern struct mdp_table_entry* mdp_downscale_y_table[MDP_DOWNSCALE_MAX];
> +extern struct mdp_table_entry *mdp_downscale_x_table[MDP_DOWNSCALE_MAX];
> +extern struct mdp_table_entry *mdp_downscale_y_table[MDP_DOWNSCALE_MAX];
>  extern struct mdp_table_entry mdp_gaussian_blur_table[];
>
> -#endif  //_MDP_SCALE_TABLES_H_
> +#endif
>
>
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
