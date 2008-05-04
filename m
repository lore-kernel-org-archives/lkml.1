Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbYEDSmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbYEDSmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYEDSmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:42:36 -0400
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:53953 "EHLO
	looneymail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753732AbYEDSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:42:35 -0400
Message-ID: <481E039A.9090605@freescale.com>
Date: Sun, 04 May 2008 13:42:34 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mconf.c and bindtextdomain() -- warnings while cross-compiling
 on OS X
References: <481D344C.9080904@tabi.org> <20080504073313.GA16259@uranus.ravnborg.org>
In-Reply-To: <20080504073313.GA16259@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

> I have queued up following patch. It is obviously correct and builds without
> warnings here. Can you give it a try on your box.

...

> +static inline void const char *gettext(const char *txt) { return txt; }

Drop the "void" on this line and this patch works.

While you're at it, you'll also need this change:

--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -773,7 +773,7 @@ static void conf_string(struct menu *menu)

         while (1) {
                 int res;
-               char *heading;
+               const char *heading;

On a side note, git-diff gives me this error in mconf.c:

@@ -924,4 +924,4 @@ int main(int ac, char **av)
         }

         return 0;
-}
+}
\ No newline at end of file

I've never seen it before so I don't know if this is specific to OS X or 
maybe it's my editor.
