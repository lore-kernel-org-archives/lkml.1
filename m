Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0CEIze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 03:55:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27670 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0CEIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 03:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=FFVCzk5fLPqMxAHX+sHxmYO27g0PXroA9EJBOxzcuPBz4oEYLCPWR75HZ7Gr5YXTBU
         n/mbskBHiVMhiATuf7xSjA2TUPxzRaUUhCBNT7rAB2eBupRuB4r65Y8kKaRTXJJSO9FF
         dS6xXWOzxqdYY/+uWm73jBFMY0VDg2NjOenrY=
Message-ID: <4B90C701.3070308@gmail.com>
Date: Fri, 05 Mar 2010 09:55:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: git@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: gitignore broken in git 1.7.0.1: slash checks leading dirs
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

having 'linux' line in .gitignore makes 'include/linux/vga_switcheroo.h'
to be ignored though the documentation says:
***
If the pattern does not contain a slash /, git treats it as a shell
glob pattern and checks for a match against the pathname without
leading directories.
***

$ touch test
$ touch include/linux/vga_asdads.h
$ git ls-files -o --exclude-from=test
include/linux/vga_asdads.h
test
$ echo linux >test
$ git ls-files -o --exclude-from=test
test

This does not happen with git 1.6.

thanks,
-- 
js
