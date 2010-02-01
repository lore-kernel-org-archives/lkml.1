Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0BAD0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 22:26:10 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:38621 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0BAD0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 22:26:08 -0500
Date: Mon, 1 Feb 2010 04:25:54 +0100
From: Daniel Mack <daniel@caiaq.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net
Subject: ACPI device for ASUS EEEPC 1101HA not added
Message-ID: <20100201032554.GZ28972@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my new 1101HA Eeepc, the special function keys do not work. This is
because the asus-laptop driver fails to match the ACPI device named
"ASUS010". However, acpidump tells me a device with that name does
actually exist - the (simplified) disassembly of the DSDT is below.

It looks like the gigantic parser state machine fails to add that
device for whatever reason. Any ideas how to fix that?


Thanks,
Daniel


/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20090521
 */
DefinitionBlock ("out/DSDT-0x3f660430-0.aml", "DSDT", 2, "A1359", "A1359000", 0x00000000)
{

    [...]

    Scope (_SB)
    {

        [...]

        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08"))
            Name (_ADR, Zero)

            [...]

            Device (SBRG)
            {

                [...]

                Scope (\_SB)
                {
                    Name (ATKP, Zero)
                    Device (ATKD)
                    {
                        Name (_HID, "ASUS010")
                        Name (_UID, 0x01010100)

                        [...]


The full version of the dump is here:

  http://caiaq.de/download/tmp/DSDT-0x3f660430-0.dsl

