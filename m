Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXHVGhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXHVGhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXHVGhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:37:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:11479 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXHVGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVrUky4aWR/WbCuFixpN+3/m9v4ITdbp16wCPuCSXCVKDHklrWb4TG1j0C/KSWVPsVQpf8Oba3cNysaZxH9fujNqdZ2wNOb1HafccAtMC96tPSPFJT2eMvJYC3kxdmFsVHgWK7eNer3vYLQ3LPMJDuiwZlPBbBgCoegDJxuZ/xs=
Message-ID: <e5bfff550708212337h75248d9dv61771221cb5139e9@mail.gmail.com>
Date: Wed, 22 Aug 2007 08:37:01 +0200
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH] qconf: show red links for disabled options
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <Pine.LNX.4.64.0708211415340.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550708180706n48e67d24qc74847ea4462c149@mail.gmail.com>
	 <Pine.LNX.4.64.0708211415340.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Roman Zippel <zippel@linux-m68k.org> wrote:
>
> The way you currently define "disabled" means that even symbols set to 'm'
> are disabled, I don't think that's what you really mean. :) When seeing
> disabled I also first thought of the option being completely invisible due
> to dependencies.
>

Thanks for your feedback Roman.

What about something like this?

	if (sym && sym->name && !(sym->flags & SYMBOL_CONST)) {
+		bool isNotSelected = (print_filter(sym_get_string_value(sym)) == "n");
+		if (isNotSelected) {
+			const QColor c(palette().disabled().text());
+			*text += "<font color=\"" + c.name() + "\">";
+		}
		*text += QString().sprintf("<a href=\"s%p\">", sym);
		*text += str2;
		*text += "</a>";
+		if (isNotSelected)
+			*text += "</font>";


It it's ok for you I can resend a proper patch along the above lines.

> > This, together with 'Show all options', allows to quickly
> > check out why a given option is hidden.
>
> Dependencies can also be something like !FOO, in this case you want FOO to
> be disabled for option to be unhidden. So if this is intended as a simple
> "Click this link to enable this option", then this requires a bit more
> work. :)
>

No it is not intended like a 'click me to enable this option', just as
a monitor of current option value.

BTW we can have a disabled symbol in the dependency list of a
currently enabled option if this is preceded by a '!'. So that in this
case you probably would not want to click anywhere.

Thanks
Marco
