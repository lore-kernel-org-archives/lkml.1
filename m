Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZGWRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZGWRXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZGWRXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:23:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZGWRXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:23:15 -0400
Date: Thu, 23 Jul 2009 19:23:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Matrix keyboard support for HTC Dream
Message-ID: <20090723172308.GA30706@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is completely untested, but I took a look at matrix_keypad to see
how it should look like. ... probably something like this :-).
								Pavel

/* 
 * Keyboard support for HTC Dream
 *
 * Copyright (C) 2009 Pavel Machek <pavel@ucw.cz>
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */


uint32_t dream_keymap[] = {
	KEY(0, 0, KEY_BACK),
	KEY(1, 0, KEY_HOME),
	KEY(3, 0, KEY_BACKSPACE),
	KEY(4, 0, KEY_ENTER),
	KEY(5, 0, KEY_RIGHTSHIFT),
	KEY(6, 0, KEY_P),

	KEY(0, 1, KEY_MENU), /* external menu key */
	KEY(1, 1, KEY_SEND),
	KEY(3, 1, KEY_LEFTSHIFT),
	KEY(4, 1, KEY_A),
	KEY(5, 1, KEY_F1), /* qwerty menu key */
	KEY(6, 1, KEY_Q),

	KEY(0, 2, KEY_U),
	KEY(1, 2, KEY_7),
	KEY(2, 2, KEY_K),
	KEY(3, 2, KEY_J),
	KEY(4, 2, KEY_M),
	KEY(5, 2, KEY_DOT),
	KEY(6, 2, KEY_8),

	KEY(0, 3, KEY_5),
	KEY(1, 3, KEY_6),
	KEY(2, 3, KEY_B),
	KEY(3, 3, KEY_H),
	KEY(4, 3, KEY_N),
	KEY(5, 3, KEY_SPACE),
	KEY(6, 3, KEY_Y),

	KEY(0, 4, KEY_4),
	KEY(1, 4, KEY_R),
	KEY(2, 4, KEY_V),
	KEY(3, 4, KEY_G),
	KEY(4, 4, KEY_C),
	KEY(5, 4, KEY_EMAIL), // @
	KEY(6, 4, KEY_T),

	KEY(0, 5, KEY_2),
	KEY(1, 5, KEY_W),
	KEY(2, 5, KEY_LEFTALT),
	KEY(3, 5, KEY_VOLUMEUP),
	KEY(4, 5, KEY_S),
	KEY(5, 5, KEY_Z),
	KEY(6, 5, KEY_1),

	KEY(0, 6, KEY_I),
	KEY(1, 6, KEY_0),
	KEY(2, 6, KEY_O),
	KEY(3, 6, KEY_L),
	KEY(4, 6, KEY_COMMA),
	KEY(5, 6, KEY_RIGHTALT),
	KEY(6, 6, KEY_9),

	KEY(0, 7, KEY_3),
	KEY(1, 7, KEY_E),
	KEY(2, 7, KEY_COMPOSE),
	KEY(3, 7, KEY_VOLUMEDOWN),
	KEY(4, 7, KEY_X),
	KEY(5, 7, KEY_F),
	KEY(6, 7, KEY_D)
}

struct matrix_keymap_data dream_map_data {
	.keymap = dream_keymap,
	.keymap_size = ARRAY_SIZE(dream_keymap),
	.max_keymap_size = ARRAY_SIZE(dream_keymap),
}

struct matrix_keypad_platform_data {
	.keymap_data = &dream_map_data;

	.row_gpios = { 42, 41, 40, 39, 38, 37, 36 };
	.col_gpios = { 35, 34, 33, 32, 31, 23, 30, 109 };
	.num_row_gpios = 7;
	.num_col_gpios = 8;

	.col_scan_delay_us = 10;

	/* key debounce interval in milli-second */
	.debounce_ms = 10;

	.active_low = 0;
	.wakeup = 0;
};


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
