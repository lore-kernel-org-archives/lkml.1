Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZJUUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZJUUoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZJUUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:44:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZJUUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=k3f5D/gDJ2Fb5LWWpLmZTwU7Hio3+vIcX/h+gAyy7OrUG93OrecT8Bm6wh9Z2u59F9
         UQtIULHsJ4x/MoUNDt00SHbwnCLwrbRpLFFiWsBUlqOpK6lbB/2CanRkrtV3GMoFDCW1
         f8pL3OjKsLCIiZOJd4PFKjtOn9N/RSuECCRc4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:43:57 +0200
Message-Id: <20091021204357.4593.77969.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/12] Staging: rt28x0: remove unused code from common/ee_efuse-c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove unused code from common/ee_efuse-c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/ee_efuse.c |  340 -------------------------------
 drivers/staging/rt2860/rtmp.h            |   12 -
 2 files changed, 352 deletions(-)

Index: b/drivers/staging/rt2860/common/ee_efuse.c
===================================================================
--- a/drivers/staging/rt2860/common/ee_efuse.c
+++ b/drivers/staging/rt2860/common/ee_efuse.c
@@ -67,31 +67,6 @@ typedef	union	_EFUSE_CTRL_STRUC {
 	UINT32			word;
 }	EFUSE_CTRL_STRUC, *PEFUSE_CTRL_STRUC;
 
-static UCHAR eFuseReadRegisters(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT Offset,
-	IN	USHORT Length,
-	OUT	USHORT* pData);
-
-static VOID eFuseReadPhysical(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	PUSHORT lpInBuffer,
-	IN	ULONG nInBufferSize,
-	OUT	PUSHORT lpOutBuffer,
-	IN	ULONG nOutBufferSize);
-
-static VOID eFusePhysicalWriteRegisters(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT Offset,
-	IN	USHORT Length,
-	OUT	USHORT* pData);
-
-static NTSTATUS eFuseWriteRegisters(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT Offset,
-	IN	USHORT Length,
-	IN	USHORT* pData);
-
 static VOID eFuseWritePhysical(
 	IN	PRTMP_ADAPTER	pAd,
 	PUSHORT lpInBuffer,
@@ -306,37 +281,6 @@ static VOID eFuseReadPhysical(
 
 ========================================================================
 */
-NTSTATUS eFuseRead(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT			Offset,
-	OUT	PUCHAR			pData,
-	IN	USHORT			Length)
-{
-	USHORT* pOutBuf = (USHORT*)pData;
-	NTSTATUS Status = STATUS_SUCCESS;
-	UCHAR	EFSROM_AOUT;
-	int	i;
-
-	for(i=0; i<Length; i+=2)
-	{
-		EFSROM_AOUT = eFuseReadRegisters(pAd, Offset+i, 2, &pOutBuf[i/2]);
-	}
-	return Status;
-}
-
-/*
-========================================================================
-
-	Routine Description:
-
-	Arguments:
-
-	Return Value:
-
-	Note:
-
-========================================================================
-*/
 static VOID eFusePhysicalWriteRegisters(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	USHORT Offset,
@@ -450,247 +394,6 @@ static VOID eFusePhysicalWriteRegisters(
 
 ========================================================================
 */
-static NTSTATUS eFuseWriteRegisters(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT Offset,
-	IN	USHORT Length,
-	IN	USHORT* pData)
-{
-	USHORT	i,Loop=0;
-	USHORT	eFuseData;
-	USHORT	LogicalAddress, BlkNum = 0xffff;
-	UCHAR	EFSROM_AOUT;
-
-	USHORT addr,tmpaddr, InBuf[3], tmpOffset;
-	USHORT buffer[8];
-	BOOLEAN		bWriteSuccess = TRUE;
-
-	DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters Offset=%x, pData=%x\n", Offset, *pData));
-
-	//Step 0. find the entry in the mapping table
-	//The address of EEPROM is 2-bytes alignment.
-	//The last bit is used for alignment, so it must be 0.
-	tmpOffset = Offset & 0xfffe;
-	EFSROM_AOUT = eFuseReadRegisters(pAd, tmpOffset, 2, &eFuseData);
-
-	if( EFSROM_AOUT == 0x3f)
-	{	//find available logical address pointer
-		//the logical address does not exist, find an empty one
-		//from the first address of block 45=16*45=0x2d0 to the last address of block 47
-		//==>48*16-3(reserved)=2FC
-		for (i=EFUSE_USAGE_MAP_START; i<=EFUSE_USAGE_MAP_END; i+=2)
-		{
-			//Retrive the logical block nubmer form each logical address pointer
-			//It will access two logical address pointer each time.
-			eFusePhysicalReadRegisters(pAd, i, 2, &LogicalAddress);
-			if( (LogicalAddress & 0xff) == 0)
-			{//Not used logical address pointer
-				BlkNum = i-EFUSE_USAGE_MAP_START;
-				break;
-			}
-			else if(( (LogicalAddress >> 8) & 0xff) == 0)
-			{//Not used logical address pointer
-				if (i != EFUSE_USAGE_MAP_END)
-				{
-					BlkNum = i-EFUSE_USAGE_MAP_START+1;
-				}
-				break;
-			}
-		}
-	}
-	else
-	{
-		BlkNum = EFSROM_AOUT;
-	}
-
-	DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters BlkNum = %d \n", BlkNum));
-
-	if(BlkNum == 0xffff)
-	{
-		DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space!!!\n"));
-		return FALSE;
-	}
-
-	//Step 1. Save data of this block	which is pointed by the avaible logical address pointer
-	// read and save the original block data
-	for(i =0; i<8; i++)
-	{
-		addr = BlkNum * 0x10 ;
-
-		InBuf[0] = addr+2*i;
-		InBuf[1] = 2;
-		InBuf[2] = 0x0;
-
-		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
-
-		buffer[i] = InBuf[2];
-	}
-
-	//Step 2. Update the data in buffer, and write the data to Efuse
-	buffer[ (Offset >> 1) % 8] = pData[0];
-
-	do
-	{	Loop++;
-		//Step 3. Write the data to Efuse
-		if(!bWriteSuccess)
-		{
-			for(i =0; i<8; i++)
-			{
-				addr = BlkNum * 0x10 ;
-
-				InBuf[0] = addr+2*i;
-				InBuf[1] = 2;
-				InBuf[2] = buffer[i];
-
-				eFuseWritePhysical(pAd, &InBuf[0], 6, NULL, 2);
-			}
-		}
-		else
-		{
-				addr = BlkNum * 0x10 ;
-
-				InBuf[0] = addr+(Offset % 16);
-				InBuf[1] = 2;
-				InBuf[2] = pData[0];
-
-				eFuseWritePhysical(pAd, &InBuf[0], 6, NULL, 2);
-		}
-
-		//Step 4. Write mapping table
-		addr = EFUSE_USAGE_MAP_START+BlkNum;
-
-		tmpaddr = addr;
-
-		if(addr % 2 != 0)
-			addr = addr -1;
-		InBuf[0] = addr;
-		InBuf[1] = 2;
-
-		//convert the address from 10 to 8 bit ( bit7, 6 = parity and bit5 ~ 0 = bit9~4), and write to logical map entry
-		tmpOffset = Offset;
-		tmpOffset >>= 4;
-		tmpOffset |= ((~((tmpOffset & 0x01) ^ ( tmpOffset >> 1 & 0x01) ^  (tmpOffset >> 2 & 0x01) ^  (tmpOffset >> 3 & 0x01))) << 6) & 0x40;
-		tmpOffset |= ((~( (tmpOffset >> 2 & 0x01) ^ (tmpOffset >> 3 & 0x01) ^ (tmpOffset >> 4 & 0x01) ^ ( tmpOffset >> 5 & 0x01))) << 7) & 0x80;
-
-		// write the logical address
-		if(tmpaddr%2 != 0)
-			InBuf[2] = tmpOffset<<8;
-		else
-			InBuf[2] = tmpOffset;
-
-		eFuseWritePhysical(pAd,&InBuf[0], 6, NULL, 0);
-
-		//Step 5. Compare data if not the same, invalidate the mapping entry, then re-write the data until E-fuse is exhausted
-		bWriteSuccess = TRUE;
-		for(i =0; i<8; i++)
-		{
-			addr = BlkNum * 0x10 ;
-
-			InBuf[0] = addr+2*i;
-			InBuf[1] = 2;
-			InBuf[2] = 0x0;
-
-			eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
-
-			if(buffer[i] != InBuf[2])
-			{
-				bWriteSuccess = FALSE;
-				break;
-			}
-		}
-
-		//Step 6. invlidate mapping entry and find a free mapping entry if not succeed
-		if (!bWriteSuccess)
-		{
-			DBGPRINT(RT_DEBUG_TRACE, ("Not bWriteSuccess BlkNum = %d\n", BlkNum));
-
-			// the offset of current mapping entry
-			addr = EFUSE_USAGE_MAP_START+BlkNum;
-
-			//find a new mapping entry
-			BlkNum = 0xffff;
-			for (i=EFUSE_USAGE_MAP_START; i<=EFUSE_USAGE_MAP_END; i+=2)
-			{
-				eFusePhysicalReadRegisters(pAd, i, 2, &LogicalAddress);
-				if( (LogicalAddress & 0xff) == 0)
-				{
-					BlkNum = i-EFUSE_USAGE_MAP_START;
-					break;
-				}
-				else if(( (LogicalAddress >> 8) & 0xff) == 0)
-				{
-					if (i != EFUSE_USAGE_MAP_END)
-					{
-						BlkNum = i+1-EFUSE_USAGE_MAP_START;
-					}
-					break;
-				}
-			}
-			DBGPRINT(RT_DEBUG_TRACE, ("Not bWriteSuccess new BlkNum = %d\n", BlkNum));
-			if(BlkNum == 0xffff)
-			{
-				DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space!!!\n"));
-				return FALSE;
-			}
-
-			//invalidate the original mapping entry if new entry is not found
-			tmpaddr = addr;
-
-			if(addr % 2 != 0)
-				addr = addr -1;
-			InBuf[0] = addr;
-			InBuf[1] = 2;
-
-			eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
-
-			// write the logical address
-			if(tmpaddr%2 != 0)
-			{
-				// Invalidate the high byte
-				for (i=8; i<15; i++)
-				{
-					if( ( (InBuf[2] >> i) & 0x01) == 0)
-					{
-						InBuf[2] |= (0x1 <<i);
-						break;
-					}
-				}
-			}
-			else
-			{
-				// invalidate the low byte
-				for (i=0; i<8; i++)
-				{
-					if( ( (InBuf[2] >> i) & 0x01) == 0)
-					{
-						InBuf[2] |= (0x1 <<i);
-						break;
-					}
-				}
-			}
-			eFuseWritePhysical(pAd, &InBuf[0], 6, NULL, 0);
-		}
-	}
-	while (!bWriteSuccess&&Loop<2);
-	if(!bWriteSuccess)
-		DBGPRINT(RT_DEBUG_ERROR,("Efsue Write Failed!!\n"));
-	return TRUE;
-}
-
-
-/*
-========================================================================
-
-	Routine Description:
-
-	Arguments:
-
-	Return Value:
-
-	Note:
-
-========================================================================
-*/
 static VOID eFuseWritePhysical(
 	IN	PRTMP_ADAPTER	pAd,
 	PUSHORT lpInBuffer,
@@ -723,49 +426,6 @@ static VOID eFuseWritePhysical(
 	}
 }
 
-
-/*
-========================================================================
-
-	Routine Description:
-
-	Arguments:
-
-	Return Value:
-
-	Note:
-
-========================================================================
-*/
-NTSTATUS eFuseWrite(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT			Offset,
-	IN	PUCHAR			pData,
-	IN	USHORT			length)
-{
-	int i;
-	USHORT* pValueX = (PUSHORT) pData;				//value ...
-
-	// The input value=3070 will be stored as following
-	// Little-endian		S	|	S	Big-endian
-	// addr			1	0	|	0	1
-	// Ori-V			30	70	|	30	70
-	// After swapping
-	//				30	70	|	70	30
-	// Casting
-	//				3070	|	7030 (x)
-	// The swapping should be removed for big-endian
-	for(i=0; i<length; i+=2)
-	{
-		eFuseWriteRegisters(pAd, Offset+i, 2, &pValueX[i/2]);
-	}
-
-	return TRUE;
-}
-
-
-
-
 /*
 ========================================================================
 
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4052,18 +4052,6 @@ VOID eFuseGetFreeBlockCount(IN PRTMP_ADA
 
 INT eFuse_init(
 	IN PRTMP_ADAPTER pAd);
-
-NTSTATUS eFuseRead(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT			Offset,
-	OUT	PUCHAR			pData,
-	IN	USHORT			Length);
-
-NTSTATUS eFuseWrite(
-	IN	PRTMP_ADAPTER	pAd,
-	IN	USHORT			Offset,
-	IN	PUCHAR			pData,
-	IN	USHORT			length);
 //2008/09/11:KH add to support efuse-->
 #endif // RTMP_EFUSE_SUPPORT //
 
