Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZFEQcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZFEQcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZFEQa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:30:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:63228 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbZFEQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RdOOZYPyqqvrvRqt7lNdrS+5AJRf2v+U9Van7O9qUyj13KO/HrcVo3lUF1oGYlcPma
         Y1fHaWi8umf1xzOoAlGnehjuVuPEsFjpsrAeEsVBcp7pJlY9JpNpFmzkGk5xRUNdy9ur
         7iWUC6369o0GHBAqnivaiPI7YSpyHn7Dhijzk=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 5/7] MFD: ASIC3: remove SD/SDIO controller register definitions
Date: Fri,  5 Jun 2009 18:31:05 +0200
Message-Id: <1244219467-32136-6-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
References: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the base addresses remain, as they are needed to set up
the IOMEM resources.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/asic3.h |  219 +--------------------------------------------
 1 files changed, 3 insertions(+), 216 deletions(-)

diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index d2ecaaf..de3c4ad 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -286,222 +286,9 @@ struct asic3_platform_data {
  *  SDIO_CTRL         Control registers for SDIO operations
  *
  *****************************************************************************/
-#define ASIC3_SD_CONFIG_Base            0x0400 /* Assumes 32 bit addressing */
-
-#define ASIC3_SD_CONFIG_Command           0x08   /* R/W: Command */
-
-/* [0:8] SD Control Register Base Address */
-#define ASIC3_SD_CONFIG_Addr0             0x20
-
-/* [9:31] SD Control Register Base Address */
-#define ASIC3_SD_CONFIG_Addr1             0x24
-
-/* R/O: interrupt assigned to pin */
-#define ASIC3_SD_CONFIG_IntPin            0x78
-
-/*
- * Set to 0x1f to clock SD controller, 0 otherwise.
- * At 0x82 - Gated Clock Ctrl
- */
-#define ASIC3_SD_CONFIG_ClkStop           0x80
-
-/* Control clock of SD controller */
-#define ASIC3_SD_CONFIG_ClockMode         0x84
-#define ASIC3_SD_CONFIG_SDHC_PinStatus    0x88   /* R/0: SD pins status */
-#define ASIC3_SD_CONFIG_SDHC_Power1       0x90   /* Power1 - manual pwr ctrl */
-
-/* auto power up after card inserted */
-#define ASIC3_SD_CONFIG_SDHC_Power2       0x92
-
-/* auto power down when card removed */
-#define ASIC3_SD_CONFIG_SDHC_Power3       0x94
-#define ASIC3_SD_CONFIG_SDHC_CardDetect   0x98
-#define ASIC3_SD_CONFIG_SDHC_Slot         0xA0   /* R/O: support slot number */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk1  0x1E0  /* Not used */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk2  0x1E2  /* Not used*/
-
-/* GPIO Output Reg. , at 0x1EA - GPIO Output Enable Reg. */
-#define ASIC3_SD_CONFIG_SDHC_GPIO_OutAndEnable  0x1E8
-#define ASIC3_SD_CONFIG_SDHC_GPIO_Status  0x1EC  /* GPIO Status Reg. */
-
-/* Bit 1: double buffer/single buffer */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk3  0x1F0
-
-/* Memory access enable (set to 1 to access SD Controller) */
-#define SD_CONFIG_COMMAND_MAE                (1<<1)
-
-#define SD_CONFIG_CLK_ENABLE_ALL             0x1f
-
-#define SD_CONFIG_POWER1_PC_33V              0x0200    /* Set for 3.3 volts */
-#define SD_CONFIG_POWER1_PC_OFF              0x0000    /* Turn off power */
-
- /* two bits - number of cycles for card detection */
-#define SD_CONFIG_CARDDETECTMODE_CLK           ((x) & 0x3)
-
-
-#define ASIC3_SD_CTRL_Base            0x1000
-
-#define ASIC3_SD_CTRL_Cmd                  0x00
-#define ASIC3_SD_CTRL_Arg0                 0x08
-#define ASIC3_SD_CTRL_Arg1                 0x0C
-#define ASIC3_SD_CTRL_StopInternal         0x10
-#define ASIC3_SD_CTRL_TransferSectorCount  0x14
-#define ASIC3_SD_CTRL_Response0            0x18
-#define ASIC3_SD_CTRL_Response1            0x1C
-#define ASIC3_SD_CTRL_Response2            0x20
-#define ASIC3_SD_CTRL_Response3            0x24
-#define ASIC3_SD_CTRL_Response4            0x28
-#define ASIC3_SD_CTRL_Response5            0x2C
-#define ASIC3_SD_CTRL_Response6            0x30
-#define ASIC3_SD_CTRL_Response7            0x34
-#define ASIC3_SD_CTRL_CardStatus           0x38
-#define ASIC3_SD_CTRL_BufferCtrl           0x3C
-#define ASIC3_SD_CTRL_IntMaskCard          0x40
-#define ASIC3_SD_CTRL_IntMaskBuffer        0x44
-#define ASIC3_SD_CTRL_CardClockCtrl        0x48
-#define ASIC3_SD_CTRL_MemCardXferDataLen   0x4C
-#define ASIC3_SD_CTRL_MemCardOptionSetup   0x50
-#define ASIC3_SD_CTRL_ErrorStatus0         0x58
-#define ASIC3_SD_CTRL_ErrorStatus1         0x5C
-#define ASIC3_SD_CTRL_DataPort             0x60
-#define ASIC3_SD_CTRL_TransactionCtrl      0x68
-#define ASIC3_SD_CTRL_SoftwareReset        0x1C0
-
-#define SD_CTRL_SOFTWARE_RESET_CLEAR            (1<<0)
-
-#define SD_CTRL_TRANSACTIONCONTROL_SET          (1<<8)
-
-#define SD_CTRL_CARDCLOCKCONTROL_FOR_SD_CARD    (1<<15)
-#define SD_CTRL_CARDCLOCKCONTROL_ENABLE_CLOCK   (1<<8)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_512    (1<<7)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_256    (1<<6)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_128    (1<<5)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_64     (1<<4)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_32     (1<<3)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_16     (1<<2)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_8      (1<<1)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_4      (1<<0)
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_2      (0<<0)
-
-#define MEM_CARD_OPTION_REQUIRED                   0x000e
-#define MEM_CARD_OPTION_DATA_RESPONSE_TIMEOUT(x)   (((x) & 0x0f) << 4)
-#define MEM_CARD_OPTION_C2_MODULE_NOT_PRESENT      (1<<14)
-#define MEM_CARD_OPTION_DATA_XFR_WIDTH_1           (1<<15)
-#define MEM_CARD_OPTION_DATA_XFR_WIDTH_4           0
-
-#define SD_CTRL_COMMAND_INDEX(x)                   ((x) & 0x3f)
-#define SD_CTRL_COMMAND_TYPE_CMD                   (0 << 6)
-#define SD_CTRL_COMMAND_TYPE_ACMD                  (1 << 6)
-#define SD_CTRL_COMMAND_TYPE_AUTHENTICATION        (2 << 6)
-#define SD_CTRL_COMMAND_RESPONSE_TYPE_NORMAL       (0 << 8)
-#define SD_CTRL_COMMAND_RESPONSE_TYPE_EXT_R1       (4 << 8)
-#define SD_CTRL_COMMAND_RESPONSE_TYPE_EXT_R1B      (5 << 8)
-#define SD_CTRL_COMMAND_RESPONSE_TYPE_EXT_R2       (6 << 8)
-#define SD_CTRL_COMMAND_RESPONSE_TYPE_EXT_R3       (7 << 8)
-#define SD_CTRL_COMMAND_DATA_PRESENT               (1 << 11)
-#define SD_CTRL_COMMAND_TRANSFER_READ              (1 << 12)
-#define SD_CTRL_COMMAND_TRANSFER_WRITE             (0 << 12)
-#define SD_CTRL_COMMAND_MULTI_BLOCK                (1 << 13)
-#define SD_CTRL_COMMAND_SECURITY_CMD               (1 << 14)
-
-#define SD_CTRL_STOP_INTERNAL_ISSSUE_CMD12         (1 << 0)
-#define SD_CTRL_STOP_INTERNAL_AUTO_ISSUE_CMD12     (1 << 8)
-
-#define SD_CTRL_CARDSTATUS_RESPONSE_END            (1 << 0)
-#define SD_CTRL_CARDSTATUS_RW_END                  (1 << 2)
-#define SD_CTRL_CARDSTATUS_CARD_REMOVED_0          (1 << 3)
-#define SD_CTRL_CARDSTATUS_CARD_INSERTED_0         (1 << 4)
-#define SD_CTRL_CARDSTATUS_SIGNAL_STATE_PRESENT_0  (1 << 5)
-#define SD_CTRL_CARDSTATUS_WRITE_PROTECT           (1 << 7)
-#define SD_CTRL_CARDSTATUS_CARD_REMOVED_3          (1 << 8)
-#define SD_CTRL_CARDSTATUS_CARD_INSERTED_3         (1 << 9)
-#define SD_CTRL_CARDSTATUS_SIGNAL_STATE_PRESENT_3  (1 << 10)
-
-#define SD_CTRL_BUFFERSTATUS_CMD_INDEX_ERROR       (1 << 0)
-#define SD_CTRL_BUFFERSTATUS_CRC_ERROR             (1 << 1)
-#define SD_CTRL_BUFFERSTATUS_STOP_BIT_END_ERROR    (1 << 2)
-#define SD_CTRL_BUFFERSTATUS_DATA_TIMEOUT          (1 << 3)
-#define SD_CTRL_BUFFERSTATUS_BUFFER_OVERFLOW       (1 << 4)
-#define SD_CTRL_BUFFERSTATUS_BUFFER_UNDERFLOW      (1 << 5)
-#define SD_CTRL_BUFFERSTATUS_CMD_TIMEOUT           (1 << 6)
-#define SD_CTRL_BUFFERSTATUS_UNK7                  (1 << 7)
-#define SD_CTRL_BUFFERSTATUS_BUFFER_READ_ENABLE    (1 << 8)
-#define SD_CTRL_BUFFERSTATUS_BUFFER_WRITE_ENABLE   (1 << 9)
-#define SD_CTRL_BUFFERSTATUS_ILLEGAL_FUNCTION      (1 << 13)
-#define SD_CTRL_BUFFERSTATUS_CMD_BUSY              (1 << 14)
-#define SD_CTRL_BUFFERSTATUS_ILLEGAL_ACCESS        (1 << 15)
-
-#define SD_CTRL_INTMASKCARD_RESPONSE_END           (1 << 0)
-#define SD_CTRL_INTMASKCARD_RW_END                 (1 << 2)
-#define SD_CTRL_INTMASKCARD_CARD_REMOVED_0         (1 << 3)
-#define SD_CTRL_INTMASKCARD_CARD_INSERTED_0        (1 << 4)
-#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_0 (1 << 5)
-#define SD_CTRL_INTMASKCARD_UNK6                   (1 << 6)
-#define SD_CTRL_INTMASKCARD_WRITE_PROTECT          (1 << 7)
-#define SD_CTRL_INTMASKCARD_CARD_REMOVED_3         (1 << 8)
-#define SD_CTRL_INTMASKCARD_CARD_INSERTED_3        (1 << 9)
-#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_3 (1 << 10)
-
-#define SD_CTRL_INTMASKBUFFER_CMD_INDEX_ERROR      (1 << 0)
-#define SD_CTRL_INTMASKBUFFER_CRC_ERROR            (1 << 1)
-#define SD_CTRL_INTMASKBUFFER_STOP_BIT_END_ERROR   (1 << 2)
-#define SD_CTRL_INTMASKBUFFER_DATA_TIMEOUT         (1 << 3)
-#define SD_CTRL_INTMASKBUFFER_BUFFER_OVERFLOW      (1 << 4)
-#define SD_CTRL_INTMASKBUFFER_BUFFER_UNDERFLOW     (1 << 5)
-#define SD_CTRL_INTMASKBUFFER_CMD_TIMEOUT          (1 << 6)
-#define SD_CTRL_INTMASKBUFFER_UNK7                 (1 << 7)
-#define SD_CTRL_INTMASKBUFFER_BUFFER_READ_ENABLE   (1 << 8)
-#define SD_CTRL_INTMASKBUFFER_BUFFER_WRITE_ENABLE  (1 << 9)
-#define SD_CTRL_INTMASKBUFFER_ILLEGAL_FUNCTION     (1 << 13)
-#define SD_CTRL_INTMASKBUFFER_CMD_BUSY             (1 << 14)
-#define SD_CTRL_INTMASKBUFFER_ILLEGAL_ACCESS       (1 << 15)
-
-#define SD_CTRL_DETAIL0_RESPONSE_CMD_ERROR                   (1 << 0)
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_NON_CMD12 (1 << 2)
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_CMD12     (1 << 3)
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_READ_DATA          (1 << 4)
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_WRITE_CRC_STATUS   (1 << 5)
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_NON_CMD12     (1 << 8)
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_CMD12         (1 << 9)
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_READ_DATA              (1 << 10)
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_WRITE_CMD              (1 << 11)
-
-#define SD_CTRL_DETAIL1_NO_CMD_RESPONSE                      (1 << 0)
-#define SD_CTRL_DETAIL1_TIMEOUT_READ_DATA                    (1 << 4)
-#define SD_CTRL_DETAIL1_TIMEOUT_CRS_STATUS                   (1 << 5)
-#define SD_CTRL_DETAIL1_TIMEOUT_CRC_BUSY                     (1 << 6)
-
-#define ASIC3_SDIO_CTRL_Base          0x1200
-
-#define ASIC3_SDIO_CTRL_Cmd                  0x00
-#define ASIC3_SDIO_CTRL_CardPortSel          0x04
-#define ASIC3_SDIO_CTRL_Arg0                 0x08
-#define ASIC3_SDIO_CTRL_Arg1                 0x0C
-#define ASIC3_SDIO_CTRL_TransferBlockCount   0x14
-#define ASIC3_SDIO_CTRL_Response0            0x18
-#define ASIC3_SDIO_CTRL_Response1            0x1C
-#define ASIC3_SDIO_CTRL_Response2            0x20
-#define ASIC3_SDIO_CTRL_Response3            0x24
-#define ASIC3_SDIO_CTRL_Response4            0x28
-#define ASIC3_SDIO_CTRL_Response5            0x2C
-#define ASIC3_SDIO_CTRL_Response6            0x30
-#define ASIC3_SDIO_CTRL_Response7            0x34
-#define ASIC3_SDIO_CTRL_CardStatus           0x38
-#define ASIC3_SDIO_CTRL_BufferCtrl           0x3C
-#define ASIC3_SDIO_CTRL_IntMaskCard          0x40
-#define ASIC3_SDIO_CTRL_IntMaskBuffer        0x44
-#define ASIC3_SDIO_CTRL_CardXferDataLen      0x4C
-#define ASIC3_SDIO_CTRL_CardOptionSetup      0x50
-#define ASIC3_SDIO_CTRL_ErrorStatus0         0x54
-#define ASIC3_SDIO_CTRL_ErrorStatus1         0x58
-#define ASIC3_SDIO_CTRL_DataPort             0x60
-#define ASIC3_SDIO_CTRL_TransactionCtrl      0x68
-#define ASIC3_SDIO_CTRL_CardIntCtrl          0x6C
-#define ASIC3_SDIO_CTRL_ClocknWaitCtrl       0x70
-#define ASIC3_SDIO_CTRL_HostInformation      0x74
-#define ASIC3_SDIO_CTRL_ErrorCtrl            0x78
-#define ASIC3_SDIO_CTRL_LEDCtrl              0x7C
-#define ASIC3_SDIO_CTRL_SoftwareReset        0x1C0
+#define ASIC3_SD_CONFIG_BASE	0x0400 /* Assumes 32 bit addressing */
+#define ASIC3_SD_CTRL_BASE	0x1000
+#define ASIC3_SDIO_CTRL_BASE	0x1200
 
 #define ASIC3_MAP_SIZE_32BIT	0x2000
 #define ASIC3_MAP_SIZE_16BIT	0x1000
-- 
1.6.3.1

