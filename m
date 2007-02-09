Return-Path: <linux-kernel-owner+w=401wt.eu-S1946514AbXBIPKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946514AbXBIPKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946510AbXBIPKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:10:34 -0500
Received: from javad.com ([216.122.176.236]:2361 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946515AbXBIPKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:10:32 -0500
From: Sergei Organov <osv@javad.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
Date: Fri, 09 Feb 2007 18:10:20 +0300
In-Reply-To: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Thu, 8 Feb 2007 19:42:07 +0100 (MET)")
Message-ID: <87veibqsdf.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:
> On Feb 8 2007 08:33, Linus Torvalds wrote:
>>
[...]
> What C needs is a distinction between char and int8_t, rendering "char" 
> an unsigned at all times basically and making "unsigned char" and 
> "signed char" illegal types in turn.

AFAIK, C already has 3 *distinct* types, "char", "signed char", and
"unsigned char". So your int8_t reads "signed char" in C, uint8_t reads
"unsigned char" in C, while "char" is yet another type that is not
compatible with those two. Yes, the names for these types are somewhat
confusing, but that's due to historical reasons, I think.

Overall,

signed char   == tiny signed int   == tiny int
unsigned char == tiny unsigned int
char != signed char
char != unsigned char

where

tiny == short short ;)

Rules of thumb: don't use bare char to store integers; don't use
signed/unsigned char to store characters.

[strxxx() routines take char* arguments as they work on '\0'-terminated
character arrays (strings). Using them on arrays of tiny integers is
unsafe no matter how char behaves on given platform (like signed or like
unsigned type).]

-- Sergei.
