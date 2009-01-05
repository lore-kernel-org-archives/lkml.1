Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZAEXvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZAEXvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZAEXvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:51:22 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:62917 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZAEXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:51:21 -0500
Message-ID: <49629CCA.90405@oracle.com>
Date: Mon, 05 Jan 2009 15:50:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Can kernel-doc process simple macros?
References: <ed82fe3e0901051536n5858d823r4c2a7f8eaa74ca4e@mail.gmail.com>
In-Reply-To: <ed82fe3e0901051536n5858d823r4c2a7f8eaa74ca4e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49629CD4.0049:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> How can I get kernel-doc to document a line like this:
> 
> #define MY_CONSTANT 10
> 
> The documentation doesn't say anything about macros, but Google
> searches imply that there is some support for macros in kernel-doc.

kernel-doc supports macros that look like functions.  E.g., from
include/linux/kernel.h:

/**
 * container_of - cast a member of a structure out to the containing structure
 * @ptr:	the pointer to the member.
 * @type:	the type of the container struct this is embedded in.
 * @member:	the name of the member within the struct.
 *
 */
#define container_of(ptr, type, member) ({			\
	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})


However, it does not supports simple macros that are just value names
like your example.  But it does support enums, so you could possibly
change the #defined values to enums and have kernel-doc for them.
Or we could see what it would take to support simple macro values
in kernel-doc...

~Randy
