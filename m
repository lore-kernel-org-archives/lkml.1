Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXIESkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXIESkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 14:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXIESk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 14:40:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22705 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbXIESk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 14:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fQ4BfzZTh0RhldbK2JGJPF48hn7MV4RU6rgXW5ZQWmcX5Qjw+a1IhOdVM6WUYYMplT8R1FLKr7GIrum+2d8L+UGElsDTSNMifY/A7Y61ifLgbC232GItznha7rKZZeec581TzAWza0QiFUK9EtQsIY3rnprLTYiLpOkTBYJECFU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: sam@ravnborg.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Date: Wed, 5 Sep 2007 19:40:15 +0100
User-Agent: KMail/1.9.1
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051449.22567.vda.linux@googlemail.com> <200709051455.05508.vda.linux@googlemail.com>
In-Reply-To: <200709051455.05508.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051940.15653.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 14:55, Denys Vlasenko wrote:
> Part 3:
> 
> Makefile:
> init/Kconfig:
>   add config DISCARD_UNUSED_SECTIONS with appropriate
>   big scary warning. It enables gcc and ld options
>   for section garbage collection.

At it typically happens, last-minute "obviously correct" change was a mistake.

This doesn't work as intended:

LDFLAGS_vmlinux += $(call ld-option, --gc-sections)

With the above line, --gc-sections doesn't get added,
and vmlinux is not garbage collected.

It must be

LDFLAGS_vmlinux += --gc-sections

Sorry.
--
vda
