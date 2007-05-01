Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXEAPuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXEAPuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXEAPuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:50:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:46770 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbXEAPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FN6vtu6Hpkqp8p+K44ARXarq1EvqmJeb2A8aJL0v0a4/k58vOfAfk1141/bheWtw6WpytHuF9SCYAsi7kBpasHEirAo9wm7UHybNXf19b925WB7qOwzH6dmMPEzxFsAsuHrLH1Hw66bEkjrd3dcPZ6XrVkqVUzpHLtXXtd2LHlI=
Message-ID: <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
Date: Tue, 1 May 2007 11:49:58 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: console font limits
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
In-Reply-To: <46375738.1010007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	 <Pine.LNX.4.64.0705011347300.27246@anakin>
	 <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Antonino A. Daplas wrote:
> >
> > And this will entail a lot of work to change (Is it worth it to rework
> > the code and remove the limitation?). The linux-console project
> > (http://linuxconsole.sourceforge.net/) might have , but I don't know its
> > current status.
>
> Well, I think the consensus is that anything beyond that should be done
> in userspace; the main such console daemon was Kon2 last I checked.

Font size is not a sane place to draw the line. Features are.
The levels of support go something like this:

0. 7-bit ASCII
1. Simple direct-to-font VGA characters.
2. UTF-8 and large fonts, but no compositing or wide characters.
3. Simple compositing and double-wide characters. (like xterm)
4. Right-to-left. (like Kermit95)
5. Complex shaping, glyph substitution, and vertical text.

Without large fonts, UTF-8 is 90% pointless bloat.

Userspace console daemons are rotten to the core. There is no safe and
reliable way to make kernel messages pass through the userspace console.
You'd either be in graphics mode or you'd still be subject to the limit
of 256 simultaneous glyphs while normal VGA attributes are in use. This
is so defective that one might as well just run X with a fullscreen xterm.
If userspace is your answer, then let's rip out the UTF-8 code.

Personally I don't even need #1, but I think anything less than #3 is
really rude toward people outside of Europe+Americas. I especially hate
to hear Europeans argue against this when they have 100% precomposed
characters for themselves and appear to have played a role (via ISO votes)
in denying stuff like the mere 12 precomposed characters needed to use
the Yoruba language with simple renderers.
