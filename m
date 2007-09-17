Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXIQPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXIQPOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXIQPOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:14:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbXIQPOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:14:11 -0400
Message-ID: <46EE99C0.5020106@redhat.com>
Date: Mon, 17 Sep 2007 11:14:08 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EDD still failing on some systems with 2.6.23-rc6-git2
References: <46EAA9A1.1080100@redhat.com> <46EAB179.4030805@zytor.com>
In-Reply-To: <46EAB179.4030805@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2007 12:06 PM, H. Peter Anvin wrote:
> Chuck Ebbert wrote:
>> I added debugging code to print a letter for each step in i386 setup,
>> and it gets to 'J', then it hangs:
>>
>>         /* Query EDD information */
>> #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
>>         putchar('J');
>>         query_edd();
>> #endif
>>
>> Multiple reports of this happening on 2.6.23-rc6 can be found at
>> the end of:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=251724
>> https://bugzilla.redhat.com/show_bug.cgi?id=239585
> 
> I just attached a test patch to the bug report shown above.  If someone
> with access to the relevant hardware could test out the patch, I would
> greatly appreciate it.
> 

Still fails. And apparently fails on disk 0, because it hangs right
after printing a zero:

--- linux-2.6.22.noarch.orig/arch/i386/boot/edd.c
+++ linux-2.6.22.noarch/arch/i386/boot/edd.c
@@ -151,6 +151,7 @@ void query_edd(void)
                 * Scan the BIOS-supported hard disks and query EDD
                 * information...
                 */
+               putchar('0' + (devno - 0x80) % 10);
                get_edd_info(devno, &ei);

                if (boot_params.eddbuf_entries < EDDMAXNR) {
