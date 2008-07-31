Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYGaGre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYGaGre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYGaGrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:47:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33435 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYGaGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:47:24 -0400
Date: Thu, 31 Jul 2008 15:40:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 2/3] kmsg: Kernel message catalog script.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Joe Perches <joe@perches.com>,
       Jochen =?ISO-2022-JP?B?Vm8bJEIhLBsoQg==?= 
	<jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20080730171157.170172806@de.ibm.com>
References: <20080730165656.118280544@de.ibm.com> <20080730171157.170172806@de.ibm.com>
Message-Id: <20080731153741.55A6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Michael Holzheu <holzheu@de.ibm.com>
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add a script and the calls to the make process that allows to check the
> kmsg printk messages and to format man pages from the message descriptions.
> 
> The kmsg message description is a comment with the following format:
> 
> /*?
>  * Tag: <component>.<id>
>  * Text: "<kmsg message text>"
>  * Severity: <severity>
>  * Parameter:
>  *   @1: <description of the first message parameter>
>  *   @2: <description of the second message parameter>
>  *   ...
>  * Description:
>  * <What is the kmsg message all about>
>  * User action:
>  * <What can the user do to fix the problem>
>  */
> 
> The script looks for a kmsg comment for a kmsg printk at three places,
> the source file where the kmsg call is located, in the architecture
> dependent file Documentation/kmsg/$ARCH/<component> and in the common
> file Documentation/kmsg/<component>.
> 
> The kmsg check is invoked with "make D=1" and reads the source files for
> all objects that are built by the current configuration and searches for
> matching kmsg descriptions for the kmsg messages in the source which
> have a messages id > 0. If a message description can not be found the
> script prints a blueprint and causes a make error.
> 
> The kmsg man page creation is invoked with "make D=2" and reads the source
> files for all built objects, looks up the message description and writes
> a man page to $(objtree)/man.

I don't know message id numbering is good or bad.
but I like a check script/Makefile of printk format changing.
because many people(include me :) often forget printk/Documentation change.

Thanks

