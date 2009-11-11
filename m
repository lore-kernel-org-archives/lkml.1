Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZKKRcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZKKRcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbZKKRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:32:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43031 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbZKKRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:32:09 -0500
Date: Wed, 11 Nov 2009 09:31:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de
Subject: [PATCH -next] staging/vt665*: fix printk formats
Message-Id: <20091111093142.30ad84d0.randy.dunlap@oracle.com>
In-Reply-To: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
References: <20091111203159.a2a6eeeb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AFAF516.00BD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in vt665[56]:

drivers/staging/vt6655/wpa.c:150: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'
drivers/staging/vt6655/wpa.c:181: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'

drivers/staging/vt6656/wpa.c:150: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'
drivers/staging/vt6656/wpa.c:181: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'
drivers/staging/vt6656/firmware.c:804: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/vt6655/wpa.c      |    4 ++--
 drivers/staging/vt6656/firmware.c |    2 +-
 drivers/staging/vt6656/wpa.c      |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20091110.orig/drivers/staging/vt6656/firmware.c
+++ linux-next-20091110/drivers/staging/vt6656/firmware.c
@@ -801,7 +801,7 @@ FIRMWAREbDownload(
                                             &(pBuffer[ii])
                                             );
 
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Download firmware...%d %ld\n", ii, sizeof(abyFirmware));
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Download firmware...%d %zu\n", ii, sizeof(abyFirmware));
             if (NdisStatus != STATUS_SUCCESS) {
                 if (pBuffer)
                     kfree(pBuffer);
--- linux-next-20091110.orig/drivers/staging/vt6656/wpa.c
+++ linux-next-20091110/drivers/staging/vt6656/wpa.c
@@ -147,7 +147,7 @@ WPA_ParseRSN (
         if (pRSN->len >= 12) //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
         {
             j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d, sizeof(pBSSList->abyPKType): %ld\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
             for(i = 0; (i < pRSN->wPKCount) && (j < sizeof(pBSSList->abyPKType)/sizeof(BYTE)); i++) {
                 if(pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
                     if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
@@ -178,7 +178,7 @@ WPA_ParseRSN (
             // overlay IE_RSN_Auth structure into correct place
             pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
             j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %ld\n",
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
                           pIE_RSN_Auth->wAuthCount, sizeof(pBSSList->abyAuthType));
             for(i = 0; (i < pIE_RSN_Auth->wAuthCount) && (j < sizeof(pBSSList->abyAuthType)/sizeof(BYTE)); i++) {
                 if(pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
--- linux-next-20091110.orig/drivers/staging/vt6655/wpa.c
+++ linux-next-20091110/drivers/staging/vt6655/wpa.c
@@ -147,7 +147,7 @@ WPA_ParseRSN (
         if (pRSN->len >= 12) //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
         {
             j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d, sizeof(pBSSList->abyPKType): %ld\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
             for(i = 0; (i < pRSN->wPKCount) && (j < sizeof(pBSSList->abyPKType)/sizeof(BYTE)); i++) {
                 if(pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
                     if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
@@ -178,7 +178,7 @@ WPA_ParseRSN (
             // overlay IE_RSN_Auth structure into correct place
             pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
             j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %ld\n",
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
                           pIE_RSN_Auth->wAuthCount, sizeof(pBSSList->abyAuthType));
             for(i = 0; (i < pIE_RSN_Auth->wAuthCount) && (j < sizeof(pBSSList->abyAuthType)/sizeof(BYTE)); i++) {
                 if(pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
