Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbYHDCgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbYHDCgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760973AbYHDCdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:33:49 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44547 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbYHDCds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:33:48 -0400
Message-ID: <57559.166.70.238.45.1217816006.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:13:26 -0600 (MDT)
Subject: [PATCH 2.6.26 17/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/debug/mdb-os.h	1969-12-31 17:00:00.000000000 -0700 +++
linux-2.6.26-mdb/debug/mdb-os.h	2008-08-03 12:49:01.000000000 -0600 @@
-0,0 +1,109 @@
+
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 3.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU +* 
 General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright +*
  contained in this code is required to be present in any derivative +*  
works and you are required to provide the source code for this +*  
program as part of any commercial or non-commercial distribution. +*   You
are required to respect the rights of the Copyright holders +*   named
within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB-OS.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_OS_H
+#define _MDB_OS_H
+
+#define MAX_SYMBOL_LEN  KSYM_NAME_LEN+1
+
+extern atomic_t inmdb;
+extern BYTE *mdb_oops;
+extern BYTE *last_mdb_oops;
+extern BYTE symbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+extern BYTE modbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+extern BYTE workbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+
+extern int mdb_kallsyms(char *str, int (*print)(char *s, ...));
+extern int mdb_modules(char *str, int (*print)(char *s, ...));
+extern int mdb_getkey(void);
+extern int mdb_getlword(unsigned long *word, unsigned long addr, size_t
size);
+extern int mdb_putword(unsigned long addr, unsigned long word, size_t size);
+extern unsigned long mdb_getword(unsigned long addr, size_t size);
+extern int mdb_verify_rw(void *addr, size_t size);
+extern ULONG ValidateAddress(ULONG addr, ULONG length);
+extern int DisplayClosestSymbol(ULONG address);
+extern void DumpOSSymbolTableMatch(BYTE *symbol);
+extern void DumpOSSymbolTable(void);
+extern ULONG GetValueFromSymbol(BYTE *symbol);
+extern BYTE *GetModuleInfoFromSymbolValue(ULONG value, BYTE *buf, ULONG
len);
+extern BYTE *GetSymbolFromValue(ULONG value, BYTE *buf, ULONG len);
+extern BYTE *GetSymbolFromValueWithOffset(ULONG value, ULONG *sym_offset,
+                                          BYTE *buf, ULONG len);
+extern BYTE *GetSymbolFromValueOffsetModule(ULONG value, ULONG
*sym_offset,
+                                     BYTE **module, BYTE *buf, ULONG len);
+extern ULONG get_processor_id(void);
+extern ULONG get_physical_processor(void);
+extern ULONG fpu_present(void);
+extern ULONG cpu_mttr_on(void);
+extern BYTE *UpcaseString(BYTE *s);
+extern void ClearScreen(void);
+extern WORD ReadFS(void);
+extern WORD ReadGS(void);
+extern ULONG ReadDR(ULONG regnum);
+extern void WriteDR(int regnum, ULONG contents);
+extern ULONG ReadCR(int regnum);
+extern void WriteCR(int regnum, ULONG contents);
+extern ULONG ReadTR(void);
+extern ULONG ReadLDTR(void);
+extern void ReadGDTR(ULONG *v);
+extern void ReadIDTR(ULONG *v);
+extern void save_npx(NUMERIC_FRAME *v);
+extern void load_npx(NUMERIC_FRAME *v);
+extern ULONG ReadDR0(void);
+extern ULONG ReadDR1(void);
+extern ULONG ReadDR2(void);
+extern ULONG ReadDR3(void);
+extern ULONG ReadDR6(void);
+extern ULONG ReadDR7(void);
+extern void WriteDR0(ULONG v);
+extern void WriteDR1(ULONG v);
+extern void WriteDR2(ULONG v);
+extern void WriteDR3(ULONG v);
+extern void WriteDR6(ULONG v);
+extern void WriteDR7(ULONG v);
+extern ULONG ReadCR0(void);
+extern ULONG ReadCR2(void);
+extern ULONG ReadCR3(void);
+extern ULONG ReadCR4(void);
+extern void WriteCR0(ULONG v);
+extern void WriteCR2(ULONG v);
+extern void WriteCR3(ULONG v);
+extern void WriteCR4(ULONG v);
+extern void ReadMSR(ULONG r, ULONG *v1, ULONG *v2);
+extern void WriteMSR(ULONG r, ULONG *v1, ULONG *v2);
+#endif
+


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey





