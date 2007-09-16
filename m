Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXIPVJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXIPVJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXIPVIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:08:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:37293 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXIPVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YLs81Se4SWhlZ0smJK8eqqlsDf+PPJ+CpXzP/7UMpthCrEPnFkUxhgdndHJdU5A9DOk8kbIMp7TK0Wyxs8fklZVzJS1YUg9YnXEnyO9V2h4LTn2DIe5ri83cFjoCSdSKQSNxC1tfyL3bYtBpF8sxrJl+LvVCxYWFEb95wYWcSZ4=
From: Matej Laitl <strohel@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH v3] menuconfig: distinguish between selected-by-another options and comments
Date: Sun, 16 Sep 2007 23:08:44 +0200
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709152004.11930.strohel@gmail.com> <200709162024.48124.strohel@gmail.com> <Pine.LNX.4.64.0709162106280.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0709162106280.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162308.45940.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 of September 2007 21:36:54 Roman Zippel wrote:
> On Sun, 16 Sep 2007, Matej Laitl wrote:
> > The v2 was maybe more intuitive, but had at least one flaw, where it claimed
> > the option was selected by another, while it was in fact only made
> > unchangeable by 'bool "Enable block layer" if EMBEDDED', defaulting to y.
> 
> The point is that I'm getting more concerned about overloading the 
> interface with nontrivial information.
> Another direction to consider would be to add this information to the help 
> text, e.g. choose one syntax for nonchangable symbols and then the user 
> can press help to find more detailed information.

If I understand clearly, something similar is already in v3 (hunk took from
in-progress v4):
@@ -359,6 +369,11 @@ static void get_symbol_str(struct gstr *r, struct symbol *sym)
 
        str_printf(r, "Symbol: %s [=%s]\n", sym->name,
                                       sym_get_string_value(sym));
+       if (sym_get_rev_dep(sym) != no)
+               str_printf(r, "Enforced value: %s (see Selected by:)\n",
+                             sym_get_rev_dep(sym) == mod ? "[m] or [y]" : "[y]");
+       if (sym_get_visibility(sym) == no)
+               str_append(r, _("None of the prompts active, default value assigned\n"));
        for_all_prompts(sym, prop)
                get_prompt_str(r, prop);

> > The function names are maybe suboptimal, I agree.
> 
> The variable name is already correct, it's the visibility value of a 
> symbol not its maximum. In the case of the "if EMBEDDED" then individual 
> menu entries can still be visible, if any child entry is visible (see 
> menu_is_visible()). 

Changed function names to sym_get_rev_dep() and sym_get_visibility().
Shouldn't I move them from symbol.c and lkc_proto.h into lkc.h? They would
fit into the section with static inline one-liners.

Bye,
     Matej.
