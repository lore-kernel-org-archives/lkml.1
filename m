Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZHPTin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZHPTin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbZHPTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:38:40 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45385 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbZHPTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dVoWgITGNv79skWrgg5T9NrWAlM0sn7h+SYXZi9Ann3IUhDWusTE0mmxhlooOeFcVq
         OXkuTckhm+BqfhkoHXmR6Hkpy76uY/Iw5Yc7IK5HXOqbonzesMKzTkWsk228a0aGl20e
         ult+f/JGV6AewoGpEeqTw/2iHD9lDWTWmV3yE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:43 +0200
Message-Id: <20090816193143.3789.39439.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/22] Staging: rtxxx0: remove unused link_list.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: remove unused link_list.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/link_list.h |  134 -------------------------------------
 drivers/staging/rt2860/rtmp.h      |    1 
 drivers/staging/rt2870/link_list.h |    1 
 drivers/staging/rt3070/link_list.h |    1 
 4 files changed, 137 deletions(-)

Index: b/drivers/staging/rt2860/link_list.h
===================================================================
--- a/drivers/staging/rt2860/link_list.h
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- *************************************************************************
- * Ralink Tech Inc.
- * 5F., No.36, Taiyuan St., Jhubei City,
- * Hsinchu County 302,
- * Taiwan, R.O.C.
- *
- * (c) Copyright 2002-2007, Ralink Technology, Inc.
- *
- * This program is free software; you can redistribute it and/or modify  *
- * it under the terms of the GNU General Public License as published by  *
- * the Free Software Foundation; either version 2 of the License, or     *
- * (at your option) any later version.                                   *
- *                                                                       *
- * This program is distributed in the hope that it will be useful,       *
- * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- * GNU General Public License for more details.                          *
- *                                                                       *
- * You should have received a copy of the GNU General Public License     *
- * along with this program; if not, write to the                         *
- * Free Software Foundation, Inc.,                                       *
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- *                                                                       *
- *************************************************************************
- */
-
-#ifndef __LINK_LIST_H__
-#define __LINK_LIST_H__
-
-typedef struct _LIST_ENTRY
-{
-	struct _LIST_ENTRY *pNext;
-} LIST_ENTRY, *PLIST_ENTRY;
-
-typedef struct _LIST_HEADR
-{
-	PLIST_ENTRY pHead;
-	PLIST_ENTRY pTail;
-	UCHAR size;
-} LIST_HEADER, *PLIST_HEADER;
-
-static inline VOID initList(
-	IN PLIST_HEADER pList)
-{
-	pList->pHead = pList->pTail = NULL;
-	pList->size = 0;
-	return;
-}
-
-static inline VOID insertTailList(
-	IN PLIST_HEADER pList,
-	IN PLIST_ENTRY pEntry)
-{
-	pEntry->pNext = NULL;
-	if (pList->pTail)
-		pList->pTail->pNext = pEntry;
-	else
-		pList->pHead = pEntry;
-	pList->pTail = pEntry;
-	pList->size++;
-
-	return;
-}
-
-static inline PLIST_ENTRY removeHeadList(
-	IN PLIST_HEADER pList)
-{
-	PLIST_ENTRY pNext;
-	PLIST_ENTRY pEntry;
-
-	pEntry = pList->pHead;
-	if (pList->pHead != NULL)
-	{
-		pNext = pList->pHead->pNext;
-		pList->pHead = pNext;
-		if (pNext == NULL)
-			pList->pTail = NULL;
-		pList->size--;
-	}
-	return pEntry;
-}
-
-static inline int getListSize(
-	IN PLIST_HEADER pList)
-{
-	return pList->size;
-}
-
-static inline PLIST_ENTRY delEntryList(
-	IN PLIST_HEADER pList,
-	IN PLIST_ENTRY pEntry)
-{
-	PLIST_ENTRY pCurEntry;
-	PLIST_ENTRY pPrvEntry;
-
-	if(pList->pHead == NULL)
-		return NULL;
-
-	if(pEntry == pList->pHead)
-	{
-		pCurEntry = pList->pHead;
-		pList->pHead = pCurEntry->pNext;
-
-		if(pList->pHead == NULL)
-			pList->pTail = NULL;
-
-		pList->size--;
-		return pCurEntry;
-	}
-
-	pPrvEntry = pList->pHead;
-	pCurEntry = pPrvEntry->pNext;
-	while(pCurEntry != NULL)
-	{
-		if (pEntry == pCurEntry)
-		{
-			pPrvEntry->pNext = pCurEntry->pNext;
-
-			if(pEntry == pList->pTail)
-				pList->pTail = pPrvEntry;
-
-			pList->size--;
-			break;
-		}
-		pPrvEntry = pCurEntry;
-		pCurEntry = pPrvEntry->pNext;
-	}
-
-	return pCurEntry;
-}
-
-#endif // ___LINK_LIST_H__ //
-
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -40,7 +40,6 @@
 #ifndef __RTMP_H__
 #define __RTMP_H__
 
-#include "link_list.h"
 #include "spectrum_def.h"
 
 #include "aironet.h"
Index: b/drivers/staging/rt2870/link_list.h
===================================================================
--- a/drivers/staging/rt2870/link_list.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2860/link_list.h"
Index: b/drivers/staging/rt3070/link_list.h
===================================================================
--- a/drivers/staging/rt3070/link_list.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../rt2870/link_list.h"
