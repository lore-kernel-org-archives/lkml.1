Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYLJXme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYLJXme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYLJXm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:42:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:51476 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYLJXmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Ffh47BT2pWKYp7wX2wPJZPIrJI/4jEa/Cpp7tiJrUd67WOD6meRmRR//BoZ6LoZa0F
         zFZmL0nP48nLRDRl5IQbJjfZXIxpcTJQyH/VzZtYqRmYkx7AVVu017azkutuljLqTe6S
         ax6vuq45SHYG3iqqiLvWpIB74aScbAmyAm4IU=
Message-ID: <88e91b480812101542m76f61eecm9d3e4dec2c8b23ea@mail.gmail.com>
Date: Wed, 10 Dec 2008 18:42:24 -0500
From: "Jonathan Barkelew" <debtech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: EFI Virtual Address Mapping - MAX PAGES too low?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've traced a series of kernel panics on one of my projects back to a
failed call to efi_ioremap in efi_64.c. In my project, there is a 4MB
region in the EFI memory map declared as EFI_MEMORY_RUNTIME, but
efi_ioremap fails if the total number of mapped pages is greater than
100:

if (pages_mapped + pages > MAX_EFI_IO_PAGES)
    return NULL;

A 4MB runtime region seems to be allowed by the EFI spec. Why is
MAX_EFI_IO_PAGES so low?

----
Jonathan Barkelew
debtech@gmail.com
