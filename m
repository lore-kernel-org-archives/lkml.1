Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0CBVyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:54:21 -0500
Received: from [206.15.93.42] ([206.15.93.42]:27843 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753429Ab0CBVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:54:19 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: remove unused global "registers"
Date: Tue, 2 Mar 2010 14:54:15 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003021454.15651.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes all the unused globally exposed copies of the boards
registers. The others will be removed in a future patch.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 6b9c685..fb3a9d6 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -25,32 +25,17 @@
 #include "dt3155_io.h"
 #include "dt3155_drv.h"
 
-
 /****** local copies of board's 32 bit registers ******/
 u32 even_dma_start_r;	/*  bit 0 should always be 0 */
 u32 odd_dma_start_r;	/*               .. */
 u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
 u32 odd_dma_stride_r;	/*               .. */
-u32 even_pixel_fmt_r;
-u32 odd_pixel_fmt_r;
 
-FIFO_TRIGGER_R		fifo_trigger_r;
-XFER_MODE_R		xfer_mode_r;
 CSR1_R			csr1_r;
-RETRY_WAIT_CNT_R	retry_wait_cnt_r;
 INT_CSR_R		int_csr_r;
 
-u32 even_fld_mask_r;
-u32 odd_fld_mask_r;
-
-MASK_LENGTH_R		mask_length_r;
-FIFO_FLAG_CNT_R		fifo_flag_cnt_r;
-IIC_CLK_DUR_R		iic_clk_dur_r;
 IIC_CSR1_R		iic_csr1_r;
 IIC_CSR2_R		iic_csr2_r;
-DMA_UPPER_LMT_R		even_dma_upper_lmt_r;
-DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
-
 
 
 /******** local copies of board's 8 bit I2C registers ******/
@@ -58,17 +43,6 @@ I2C_CSR2 i2c_csr2;
 I2C_EVEN_CSR i2c_even_csr;
 I2C_ODD_CSR i2c_odd_csr;
 I2C_CONFIG i2c_config;
-u8 i2c_dt_id;
-u8 i2c_x_clip_start;
-u8 i2c_y_clip_start;
-u8 i2c_x_clip_end;
-u8 i2c_y_clip_end;
-u8 i2c_ad_addr;
-u8 i2c_ad_lut;
-I2C_AD_CMD i2c_ad_cmd;
-u8 i2c_dig_out;
-u8 i2c_pm_lut_addr;
-u8 i2c_pm_lut_data;
 
 /*
  * wait_ibsyclr()
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index d1a2510..e8c3328 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -210,7 +210,6 @@ typedef union dma_upper_lmt_tag   {
 	} fld;
 } DMA_UPPER_LMT_R;
 
-
 /*
  * Global declarations of local copies of boards' 32 bit registers
  */
@@ -218,26 +217,12 @@ extern u32 even_dma_start_r;		/*  bit 0 should always be 0 */
 extern u32 odd_dma_start_r;		/*               ..          */
 extern u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
 extern u32 odd_dma_stride_r;		/*               ..             */
-extern u32 even_pixel_fmt_r;
-extern u32 odd_pixel_fmt_r;
 
-extern FIFO_TRIGGER_R		fifo_trigger_r;
-extern XFER_MODE_R		xfer_mode_r;
 extern CSR1_R			csr1_r;
-extern RETRY_WAIT_CNT_R		retry_wait_cnt_r;
 extern INT_CSR_R		int_csr_r;
 
-extern u32 even_fld_mask_r;
-extern u32 odd_fld_mask_r;
-
-extern MASK_LENGTH_R		mask_length_r;
-extern FIFO_FLAG_CNT_R		fifo_flag_cnt_r;
-extern IIC_CLK_DUR_R		iic_clk_dur_r;
 extern IIC_CSR1_R		iic_csr1_r;
 extern IIC_CSR2_R		iic_csr2_r;
-extern DMA_UPPER_LMT_R		even_dma_upper_lmt_r;
-extern DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
-
 
 
 /***************** 8 bit I2C register globals  ***********/
@@ -329,24 +314,12 @@ typedef union i2c_ad_cmd_tag {
 	} bt252_iout1;
 } I2C_AD_CMD;
 
-
 /***** Global declarations of local copies of boards' 8 bit I2C registers ***/
 
 extern I2C_CSR2			i2c_csr2;
 extern I2C_EVEN_CSR		i2c_even_csr;
 extern I2C_ODD_CSR		i2c_odd_csr;
 extern I2C_CONFIG		i2c_config;
-extern u8			i2c_dt_id;
-extern u8			i2c_x_clip_start;
-extern u8			i2c_y_clip_start;
-extern u8			i2c_x_clip_end;
-extern u8			i2c_y_clip_end;
-extern u8			i2c_ad_addr;
-extern u8			i2c_ad_lut;
-extern I2C_AD_CMD		i2c_ad_cmd;
-extern u8			i2c_dig_out;
-extern u8			i2c_pm_lut_addr;
-extern u8			i2c_pm_lut_data;
 
 /* Functions for Global use */
 
