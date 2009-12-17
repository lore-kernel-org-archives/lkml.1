Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZLQXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZLQXln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZLQXli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:41:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZLQXlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:41:36 -0500
Message-ID: <4B2AC191.6030802@zytor.com>
Date: Thu, 17 Dec 2009 15:41:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, mmarek@suse.cz,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC
 to C
References: <4B2A1761.4070904@suse.cz> <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org> <20091217220951.GB4236@merkur.ravnborg.org> <4B2AB07D.5010007@zytor.com> <4B2AC01E.6090509@redhat.com> <4B2AC0C0.4000005@zytor.com>
In-Reply-To: <4B2AC0C0.4000005@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060008010502020509010807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060008010502020509010807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/17/2009 03:37 PM, H. Peter Anvin wrote:
>>
>> Maybe, "LC_ALL=" line broke it?
> 
> What happens if you remove that part?
> 

I mean, of course, the references to LC_ALL.

What would be even better, actually, would be to test the following
incremental patch:

	-hpa


--------------060008010502020509010807
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/Makefile b/Makefile
index 6e39af1..5e92ca5 100644
--- a/Makefile
+++ b/Makefile
@@ -17,11 +17,11 @@ NAME = Man-Eating Seals of Antiquity
 MAKEFLAGS += -rR --no-print-directory
 
 # Avoid funny character set dependencies
-LC_ALL=
+unexport LC_ALL
 LC_CTYPE=C
 LC_COLLATE=C
 LC_NUMERIC=C
-export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
+export LC_CTYPE LC_COLLATE LC_NUMERIC
 
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.

--------------060008010502020509010807--
