Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYHDOS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYHDOS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYHDOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:18:49 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51386 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbYHDOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:18:48 -0400
Message-ID: <48970F8E.9010507@s5r6.in-berlin.de>
Date: Mon, 04 Aug 2008 16:17:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1 6/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
References: <37445.166.70.238.45.1217831466.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <37445.166.70.238.45.1217831466.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> --- a/debug/mdb.c	1969-12-31 17:00:00.000000000 -0700
> +++ b/debug/mdb.c	2008-08-03 16:15:00.000000000 -0600
[...]
> +ULONG ScreenInputFromKeyboard(BYTE *buf, ULONG buf_index, ULONG max_index)
> +{
[...]
> +    HistoryIndex = HistoryPointer;
> +    while (1)
> +    {
> +       key = mdb_getkey();
> +
> +       if ((IsAccelerator(key)) && (key != 13))
> +	  return key;
> +
> +       switch (key)
> +       {
[...]
> +	  default:
> +	     if ((key > 0x7E) || (key < ' '))  // if above or below text
> +		break;
> +	     else
> +	     {
> +	        if (strlen(buf) < max_index)
> +		{
> +                   register int delta;
> +
> +		   for (i=max_index; i > buf_index; i--)
> +		      buf[i] = buf[i-1];
> +		   buf[buf_index] = (BYTE)key;
> +		   if (buf_index < max_index)
> +		      buf_index++;
> +
> +                   delta = strlen(buf) - buf_index;
> +
> +                   for (i=0; (i < delta) && (buf[i]); i++)
> +                        DBGPrint("%c", buf[buf_index + i]);
> +
> +                   for (i=0; i < delta; i++)
> +                        DBGPrint("\b");
> +		}
> +             }
> +	     break;
> +       }
> +    }
> +}

This function would benefit from being broken up into smaller ones.
-- 
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/
