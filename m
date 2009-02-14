Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZBNMZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZBNMZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 07:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZBNMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 07:25:33 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33894 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBNMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 07:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=tL4c4i9fuAhw7MJjNXsuacgo/1wQz5EnXUjR8GMTtG9LdpcVMpTqH+Y+BpDyHO25yA
         /zdCanfhOMVQPi9dTtuDn9zOXGn3Kolub3zFE7618SkCRjdApOCMdwsW8tDrBUyoVs5A
         e6mybYj/QtYQTc0QW60TfWFSpvBnNXzbN765E=
Message-ID: <4996B838.2070205@googlemail.com>
Date: Sat, 14 Feb 2009 13:25:28 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RFC: install firmware in a kernel-dependent directory
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, make firmware_install puts all firmware blobs in
/lib/firmware. If you have several kernel versions installed, they will
overwrite each other's files, which may lead to problems if the blobs
eventually change. I think it would be better to use a separate
directory for every kernel version, like /lib/firmware/$(uname -r) or
/lib/modules/$(uname -r)/firmware (the latter is my favorite).

In either case, only a minimal modification in /lib/udev/firmware.sh is
required to make it look in the new directory first.

Comments?
-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
