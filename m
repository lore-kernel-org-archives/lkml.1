Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZAQVjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZAQVjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZAQVjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:39:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZAQVjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:39:09 -0500
Date: Sat, 17 Jan 2009 16:38:52 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
	warnings
Message-ID: <20090117213852.GC1700@bombadil.infradead.org>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org> <497248AE.10500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <497248AE.10500@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 01:07:58PM -0800, H. Peter Anvin wrote:
> Kyle McMartin wrote:
> > 
> > How about something utterly evil? (Since you can't pass a zero-length
> > string to a printf attributed function either...)
> > 
> 
> ?!
> 
> *That* should definitely be permitted... anything else is an utter bug.
> 

Sadly, 
kyle@ihatethathostname ~ $ cat foo.c
#include <stdio.h>
int main(void) {
	printf("");
	return 0;
}
kyle@ihatethathostname ~ $ gcc -O2 -Wall -o foo foo.c
foo.c: In function ‘main’:
foo.c:3: warning: zero-length printf format string

gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) 
